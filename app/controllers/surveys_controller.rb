class SurveysController < ApplicationController
  require 'open-uri'
  include ApplicationHelper

  skip_authorization_check :only => [:fill_survey, :submit_survey, :survey_sent]

  def index
    @surveys = Survey.includes(:questions).order(id: :asc)
    @survey_brochures = RelationBrochureScenarios.all.group_by(&:survey_id)
  end

  def new
    @survey = Survey.new
    respond_to do |format|
      format.js {render "surveys/new"}
      format.html
    end
  end

  def edit
    @survey = Survey.includes(:questions => :options)
                  .where(id: params[:id])
                  .order('questions.order ASC, options.order ASC').to_a.first

    redirect_to surveys_path and return if @survey.blank?

    respond_to do |format|
      format.js {render "surveys/edit"}
      format.html
    end
  end

  def show
    @answers = []
    @survey = Survey.includes(:questions => :options).order('questions.order ASC, options.order ASC').find_by_id(params[:id])

    @questions = Question.where(survey_id: params[:id]).order(:order)

    redirect_to surveys_path and return if @survey.blank?
  end

  def update
    @survey = Survey.find(params[:id])
    survey_attrs = survey_params

     #update options order
    survey_attrs[:questions_attributes].each do |key, question|
      if question[:options_attributes].present? && ((question["question_type"] == "multiple_answers") || (question["question_type"] == "multiple_choice"))
        question[:options_attributes].each do |key_option, option|
          if option['title'].present? && option['_destroy'] == "false"
            option['order'] = question[:options_attributes].to_h.find_index{|k,_| k == key_option} + 1
          end
        end
      end
    end

    @survey.update(survey_attrs)

    redirect_to surveys_path
  end

  def create
    survey_attrs = survey_params

    suvey = Survey.create

    #set options order
    survey_attrs[:questions_attributes].each do |key, question|
      if question[:options_attributes].present? && ((question["question_type"] == "multiple_answers") || (question["question_type"] == "multiple_choice"))
        question[:options_attributes].each do |key_option, option|
          if option['title'].present? && option['_destroy'] == "false"
            option['order'] = question[:options_attributes].to_h.find_index{|k,_| k == key_option} + 1
          end
        end
      end
    end

    survey_attrs["author"] = current_user.full_name
    if suvey.update survey_attrs
      flash[:notice] = "Successfully created."
      redirect_to surveys_path and return
    else
      @survey = Survey.new
      render 'new'
    end

  end

  def destroy
    @survey = Survey.find(params[:id]).delete
    flash[:notice] = "Successfully deleted."
    redirect_to surveys_path and return
  end

  def send_survey
    @survey = Survey.find_by_id(params[:id])
    @active_filters = "all"
    @metadata_member = Metadatum.where(datatype: "member").order(display_order: :asc)
    @email_template_member_fields = Metadatum.custom_fields_template(["member", "Customer", "member"], @metadata_member)
    @filters_member_fields = Metadatum.custom_fields_template(["member", "", "member"], @metadata_member)
    @specific_members = User.active.order("last_name asc, first_name asc").paginate(page: params[:page], per_page: 100)

    #link might point to new even if one is created already
    @email_template = EmailTemplate.new(EmailTemplate::GSG_DEFAULT_TEMPLATES.deep_dup[:survey])
    @email_template.email_template_type = "survey"

    respond_to do |format|
      format.html
      format.js { render 'email_templates/members_list_modal' }
    end
  end

  def get_member_metatum_values
    field = params['field']
    if field
      custom_field_id = field.split('.')[1].to_i
      membermetada = MemberMetadatum.where(metadatum_id: custom_field_id).where("value is not NULL AND value <> '' ").select('DISTINCT value')
      custom_field_values = []
      membermetada.each do |m|
        custom_field_values << ["#{m.value}", m.value]
      end
      respond_to do |format|
        format.js {render "surveys/get_member_metatum_values", locals: {custom_field_values: custom_field_values}}
      end
    end
  end

  def sync_results_page

    @survey = Survey.find_by_id(params[:id])
    @column_matching = []
    @column_unmatching = []
    @column_new = []

    #all metadata
    metadata_name = Metadatum.includes(:member_profile_category).where(datatype:  "member").pluck(:id, :name, :member_profile_category_id)
    member_metadata_profile_alfa = MemberProfileCategory
    member_metadata_profile_names = member_metadata_profile_alfa.pluck(:id, :name)

    questions = Question.where(survey_id: @survey.id).pluck(:id, :title)

    questions.each do |q|
      name_match = q[1].downcase.strip
      #matching fields
      if (db_club_value = (metadata_name.select{|m| name_match == m[1].downcase}.first || metadata_name.select{|m| name_match[m[1].downcase] || m[1].downcase[name_match] }.first)).present?
        if db_club_value[2].present?
          @column_matching << {your_id: q[0], your_name: q[1], our_id: db_club_value[0], our_name: db_club_value[1]+" (#{member_metadata_profile_names.select{|m| m[0] == db_club_value[2]}[0][1].capitalize})"}
        else
          @column_matching << {your_id: q[0], your_name: q[1], our_id: db_club_value[0], our_name: db_club_value[1]}
        end
        metadata_name = metadata_name.reject{|m| m[0] == db_club_value[0]}
      else
        @column_unmatching << {your_id: q[0], your_name: q[1], our_id: nil, our_name: nil}
      end
    end

    #available custom fields to match
    @options_for_unmachting = []
    @options_for_unmachting_final = {}
    @options_for_unmachting_final["Do not import"] = [["Skip Custom Field", "skip"]]
    @options_for_unmachting_final["New Custom Field"] = [["Create Custom Field", "new"]]

    metadata_name.each do |m|
      if m[2].present?
        @options_for_unmachting << ["#{m[1].capitalize} (#{member_metadata_profile_names.select{|mp| mp[0] == m[2]}[0][1].capitalize})", m[0]]
      else
        @options_for_unmachting << ["#{m[1].capitalize}", m[0]]
      end
    end

    @options_for_unmachting_final["Match to"] =  @options_for_unmachting


    m_p_category = member_metadata_profile_alfa.where("LOWER(name) = '#{@survey.title.gsub('\'', "''").downcase}'")
                       .first
    if m_p_category.blank?
      m_p_category = MemberProfileCategory.new({name: @survey.title,
                                                display_order: (member_metadata_profile_alfa.maximum(:display_order) || 0) + 1})
      m_p_category.save()
    end

    @member_profile_default_category = m_p_category.try(:id)

    @member_profile_categories = member_metadata_profile_alfa.map{|c| ["#{c.name.capitalize}",c.id]}
    @member_profile_categories[0,0] = [["Type..", nil]]

  end

  def sync_results
    @survey = Survey.find_by_id(params[:id])
    @column_matching = []
    @column_unmatching = []
    @column_new = []

    flash[:error] = nil

    metadata_name = Metadatum.includes(:member_profile_category).where(datatype:  "member").pluck(:id, :name, :member_profile_category_id)
    member_metadata_profile_alfa = MemberProfileCategory
    member_metadata_profile_names = member_metadata_profile_alfa.pluck(:id, :name)

    questions = Question.where(survey_id: @survey.id).pluck(:id, :title)


    #read params in case click on delete match button
    delete_match_params = params.select{|p, v| p.include?("delete_m_")}
    #read params in case click on new custom field button
    new_field_params = params.select{|p, v| p.include?("new_field_")}
    #read params in case click on delete field button
    delete_field_params = params.select{|p, v| p.include?("delete_field_")}
    #read params in case click on match field button
    btn_match = params.select{|p, v| p.include?("btn_m_new_")}
    #all match params
    match_field_paramas = params.select{|p, v| p.include?("match_")}
    #all new custom fields params
    new_custom_field_params = params.select{|p, v| p.include?("new_custom_field_category_")}
    #all new match params
    new_match_params = params.select{|p, v| p.include?("new_m_")}

    #all your columns name
    your_name_params =  params.select{|p, v| p.include?("your_name_")}
    #all our columns name
    our_name_params =  params.select{|p, v| p.include?("our_name_")}



    our_ids = []

    #prepare column_matching
    match_field_paramas.each do |key, value|
      your_id = key.split('_')[-1].to_i
      our_id = value.to_i
      our_ids << our_id
      your_name = your_name_params.select{|p, v| p.split('_')[-1].to_i == your_id}.permit!.to_h.first[1]
      our_name = our_name_params.select{|p, v| p.split('_')[-1].to_i == our_id}.permit!.to_h.first[1]
      @column_matching << {your_id: your_id, your_name: your_name, our_id: our_id, our_name: our_name}
    end

    #prepare column_unmatching
    new_match_params.each do |key, value|
      your_id = key.split('_')[-1].to_i
      your_name = your_name_params.select{|p, v| p.split('_')[-1].to_i == your_id}.permit!.to_h.first[1]
      @column_unmatching << {your_id: your_id, your_name: your_name, our_id: nil, our_name: nil}
    end

    #prepare column_new
    new_custom_field_params.each do |key, value|
      your_id = key.split('_')[-1].to_i
      your_name = your_name_params.select{|p, v| p.split('_')[-1].to_i == your_id}.permit!.to_h.first[1]
      @column_new << {your_id: your_id, your_name: your_name, our_id: nil, our_name: nil}
    end

    #available custom fields to match
    @options_for_unmachting = []
    @options_for_unmachting_final = {}
    @options_for_unmachting_final["Do not import"] = [["Skip Custom Field", "skip"]]
    @options_for_unmachting_final["New Custom Field"] = [["Create Custom Field", "new"]]


    metadata_name.each do |m|
      if !our_ids.any?{|o| o == m[0]}
        if m[2].present?
          @options_for_unmachting << ["#{m[1].capitalize} (#{member_metadata_profile_names.select{|mp| mp[0] == m[2]}[0][1].capitalize})", m[0]]
        else
          @options_for_unmachting << ["#{m[1].capitalize}", m[0]]
        end
      end
    end

    @options_for_unmachting_final["Match to"] =  @options_for_unmachting

    #read params in case click on import button
    import_custom_fields_params = params.select{|p, v| p.include?("new_custom_field_category_") || p.include?("match_")}

    if !btn_match.blank?
      #in case click on new match button
      your_id = 0
      btn_match.each do |key, value|
        your_id = key.split('_')[-1].to_i
      end
      new_match_params.each do |key, value|
        if your_id == key.split('_')[-1].to_i
          our_id = value.to_i
          your_name = @column_unmatching.select{|u| u[:your_id] == your_id}.first[:your_name]
          our_name = @options_for_unmachting_final["Match to"].select{|un| un[1] == our_id}[0][0]
          @column_matching << {your_id: your_id, your_name: your_name, our_id: our_id, our_name: our_name}
          @column_unmatching = @column_unmatching.reject{|u| u[:your_id] == your_id}
          @options_for_unmachting_final["Match to"] = @options_for_unmachting_final["Match to"].reject{|un| un[1] == our_id}
        end
      end
    elsif !delete_match_params.blank?
      # in case click on delete match button
      delete_match_params.each do |key, value|
        your_id = key.split('_')[-1].to_i
        unmatch_field = @column_matching.select{|m| m[:your_id] == your_id}[0]
        @column_matching = @column_matching.reject{|m| m[:your_id] == your_id}
        @options_for_unmachting_final["Match to"] << ["#{unmatch_field[:our_name].capitalize}", unmatch_field[:our_id]]
        unmatch_field[:our_id] = nil
        unmatch_field[:our_name] = nil
        @column_unmatching << unmatch_field
      end
    elsif !new_field_params.blank?
      # in case click on new custom field button
      new_field_params.each do |key, value|
        your_id = key.split('_')[-1].to_i
        new_field = @column_unmatching.select{|m| m[:your_id] == your_id}[0]
        @column_unmatching = @column_unmatching.reject{|m| m[:your_id] == your_id}
        @column_new << new_field
      end
    elsif !delete_field_params.blank?
      # in case click on delete field button
      delete_field_params.each do |key, value|
        your_id = key.split('_')[-1].to_i
        unmatch_field = @column_new.select{|m| m[:your_id] == your_id}[0]
        @column_new = @column_new.reject{|m| m[:your_id] == your_id}
        @column_unmatching << unmatch_field
      end
    elsif !import_custom_fields_params.blank?
      # in case click on import button
      #Schedule Import Resque
      parameters = {
        survey_id:                     @survey.id,
        import_custom_fields_params:   import_custom_fields_params,
      }
      job = Job.schedule("sync_survey_answers", parameters)

      redirect_to job_path(job.id) and return
    end

    @member_profile_default_category = member_metadata_profile_alfa
                                          .where("LOWER(name) = '#{@survey.title.gsub('\'', "''").downcase}'")
                                          .first.try(:id)

    @member_profile_categories = member_metadata_profile_alfa.map{|c| ["#{c.name}",c.id]}
    @member_profile_categories[0,0] = [["Type..", nil]]

    respond_to do |format|
      format.js
    end
  end

  def status
    survey = Survey.find_by_id(params[:id])
    new_status = (survey.status == "open" ? "closed" : "open")
    survey.update_attribute(:status, new_status)
    redirect_to surveys_path and return
  end

  def fill_survey
    @member = Member.find_by_id(params[:member_id])
    questions_ids = Question.where(survey_id: params[:id]).pluck(:id)
    @answers = MemberQuestion.where(question_id: questions_ids).where(member_id: params[:member_id]).map{|m| {m.question_id => m.answer}}
    @survey = Survey.find_by_id(params[:id])
    @questions = Question.where(survey_id: params[:id]).sort_by(&:order)

    redirect_to surveys_path and return if @survey.blank?

    respond_to do |format|
      format.html { render "layouts/survey_answer"}
    end
  end

  def submit_survey

    update_answers_for_member = []
    insert_answers_for_member = []
    multi_answers = []
    answers = []

    member = params[:member_id]
    multi_answers = params[:answer].select{|p| p.include?("multipleanswer_")} if params[:answer]
    answers = params[:answer].permit!.select{|p| !p.include?("multipleanswer_")} if params[:answer]
    member_surveys_answers = MemberQuestion.where(member_id: member).group_by(&:question_id)
    time = DateTime.now()

    multi_answers_final = {}

    multi_answers.each do |m_id, answer|
      question_id = m_id.split('_')[1].to_i
      append_value = (multi_answers_final[question_id].present? ? multi_answers_final[question_id] + ', ' : "")
      multi_answers_final[question_id] = append_value + answer.to_s
    end

    answers.each do |question_id, answer|
      if member_surveys_answers[question_id.to_i].present?
        update_answers_for_member << [{id: member_surveys_answers[question_id.to_i].first.id}, {member_id: member, question_id: question_id, answer: answer, fill_in_date: time}]
      else
        insert_answers_for_member << {member_id: member, question_id: question_id, answer: answer, fill_in_date: time}
      end
    end

    multi_answers_final.each do |question_id, answer|
      if member_surveys_answers[question_id.to_i].present?
        update_answers_for_member << [{id: member_surveys_answers[question_id.to_i].first.id}, {member_id: member, question_id: question_id, answer: answer, fill_in_date: time}]
      else
        insert_answers_for_member << {member_id: member, question_id: question_id, answer: answer, fill_in_date: time}
      end
    end

    if insert_answers_for_member.present?
      MemberQuestion.import insert_answers_for_member
    end

    if update_answers_for_member.present?
      time = Time.now
      Upsert.batch(MemberQuestion.connection, MemberQuestion.table_name) do |upsert|
        update_answers_for_member.each do |m|
          upsert.row(m[0], m[1].merge!({created_at: time, updated_at: time}))
        end
      end
    end

    redirect_to survey_sent_member_survey_path and return
  end

  def survey_sent
    setting = Setting.exist_or_create(params[:id])
    @banner_url = setting.email_banner
    @logo_url = setting.email_logo

    respond_to do |format|
      format.html { render "layouts/survey_answer_sent"}
    end
  end

  def results
    @survey = Survey.find(params[:id])
    survey_questions = Question.where(survey_id: @survey.id).sort_by(&:order)
    questions_ids = survey_questions.pluck(:id)
    answers = MemberQuestion.includes(question: :options).where(question_id: questions_ids).group_by(&:question_id)
    nb_members_who_answered =  MemberQuestion.where(question_id: questions_ids).group_by(&:member_id).count

    chart_colors = chart_schema_color
    @questions = survey_questions.map do |sq|
      # nb of skipped answers
      if answers[sq.id].blank?
        skipped_answers = 0
      elsif sq.question_type == "free_text"
        skipped_answers = answers[sq.id].inject(0) {|sum, a| sum + (a[:answer] == "" ? 1 : 0)}
      else
        skipped_answers = nb_members_who_answered - answers[sq.id].count
      end

      column_chart = get_column_chart_format sq, (answers[sq.id] || [])
      chart_colors = chart_schema_color

      [
          sq,
          answers[sq.id].present? ? answers_type(answers[sq.id], sq, nb_members_who_answered - skipped_answers, column_chart, chart_colors) : [],
          [nb_members_who_answered - skipped_answers, skipped_answers],
          chart_colors,
          column_chart.map{|a| [a.first, a.second.count]}
      ]
    end

    redirect_to surveys_path and return if @survey.blank?

    respond_to do |format|
      format.html { render 'surveys/results' }
      format.js { render 'surveys/results' }
    end
  end

  def answers_type answers, question, total_answers, column_chart, chart_colors
    if question.question_type == "free_text"
      answers.sort_by(&:fill_in_date).select { |a| a.answer.present? }.paginate(page: params["answer_#{question.id}"] || 1, per_page: 20)

    elsif question.question_type == "multiple_answers"
      # column chart (title, {option => nb of answers}, percentage)
      answer_options = []
      question.options.each do |option|
        answer_option_percentage = ((column_chart[option.title] || []).count / total_answers.to_f * 100).round(2)
        answer_options << [option.title, (column_chart[option.title] || []).count, answer_option_percentage]
      end
      answer_options.sort_by{ |ao| -ao.last}

    elsif question.question_type == "multiple_choice"
      # pie chart
      answer_options = []
      answers_legend = []
      answers_table = []
      question.options.each_with_index do |option, index|
        nb_answers_per_option = answers.inject(0) {|sum, a| sum + (a.answer == option.title ? 1 : 0)}
        answer_options << [option.title, nb_answers_per_option]

        # manual legend, each option is formed by (title, color, percentage)
        answers_legend << [option.title, chart_colors[index], (nb_answers_per_option / total_answers.to_f * 100).round(2)]
        answers_table << [option.title, (nb_answers_per_option / total_answers.to_f * 100).round(2), nb_answers_per_option]
      end
      answers_table = answers_table.sort_by{ |ao| -ao.last}
      # the last value is the maximum string length of an option, for styling the legend items width
      [answer_options, answers_legend, answers_table, question.options.max_by{ |o| o.title.length}.title.length]
    end
  end

  private


  def get_column_chart_format question, question_answers
    # we initalize with emply for free_text case (we won't have a chart for this question type)
    column_chart = []
    if question.question_type == "multiple_choice"
      # we group answers by answer (only one answer is possible)
      column_chart = question_answers.group_by{|a| a.answer}
    elsif question.question_type == "multiple_answers"
      # for multiple_answers we create an empty hash from question options
      # {"o1" => {}, "o2" => []}
      column_chart = question.options.map { |option| [option.title, []] }.to_h

      # for each answer, we split member answer "o1, o2, o3" by coma and append to it's corresponding hash key
      question_answers.each do |answer|
        options = answer.question.options
        options.each do |o|
          if (answer.answer + ', ').include?("#{o.title}, ") || answer.answer == o.title
            column_chart[o.title] << o.title
          end
        end    
      end
    end

    column_chart
  end

  def survey_params
    params.require(:survey).permit(:title, :description, :logo, :questions_attributes => [:id, :title, :question_type, :order, :_destroy, :options_attributes => [:id, :title, :order, :_destroy, :aux_description]])
  end
end
