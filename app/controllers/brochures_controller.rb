class BrochuresController < ApplicationController
  before_action :set_brochure, only: [:show, :edit, :update, :destroy]
  before_action :check_user_details
  def check_user_details
    @user = current_user
    if @user.try(:first_name).blank?
      flash[:error] = "Trebuie sa completezi detaliile profilului intai!"
      redirect_to edit_user_path(@user) and return
    end
  end
  # GET /brochures
  # GET /brochures.json
  def index
    @brochures = Brochure.all

    @brochures_submissions = BrochureAnswer.all.group_by(&:brochure_id)
    @brochures_submissions.each do |k, v|
      @brochures_submissions[k] = v.group_by{|e| e[:user_id]}.count
    end
  end

  # GET /brochures/1
  # GET /brochures/1.json
  def show
    @preview = true
    @scenarios_ids = RelationBrochureScenarios.where(brochure_id: @brochure.id).pluck(:survey_id)
    @scenarios = Survey.includes(:questions => :options).order('questions.order ASC, options.order ASC').where(id: @scenarios_ids)
    @questions = Question.where(survey_id: @scenarios_ids).sort_by(&:order).group_by(&:survey_id)
    @answers = []
    @user = current_user
  end

  # GET /brochures/new
  def new
    @brochure = Brochure.new
    @survey_brochures = [RelationBrochureScenarios.new(), RelationBrochureScenarios.new(), RelationBrochureScenarios.new(), RelationBrochureScenarios.new()]
  end

  # GET /brochures/1/edit
  def edit
    @survey_brochures = RelationBrochureScenarios.where(brochure_id: @brochure.id)
    @survey_brochures = [RelationBrochureScenarios.new(), RelationBrochureScenarios.new(), RelationBrochureScenarios.new(), RelationBrochureScenarios.new()] if @survey_brochures.blank?
  end

  # POST /brochures
  # POST /brochures.json
  def create
    @brochure = Brochure.new(brochure_params)

    @brochure.author = current_user.full_name
    if @brochure.save
      survey_brochure_params.each do |key, sb|
        RelationBrochureScenarios.create({brochure_id: @brochure.id, survey_id:sb})
      end
      respond_to do |format|
        format.html { redirect_to @brochure, notice: 'Brosura a fost creata cu success.' }
        format.json { render :show, status: :created, location: @brochure }
      end
    else
        respond_to do |format|
          format.html { render :new }
          format.json { render json: @brochure.errors, status: :unprocessable_entity }
        end
    end
  end

  # PATCH/PUT /brochures/1
  # PATCH/PUT /brochures/1.json
  def update
    RelationBrochureScenarios.where(brochure_id: @brochure.id).delete_all
    survey_brochure_params.each do |key, sb|
      RelationBrochureScenarios.create({brochure_id: @brochure.id, survey_id:sb})
    end
    respond_to do |format|
      if @brochure.update(brochure_params)
        format.html { redirect_to @brochure, notice: 'Brosura s-a updatat cu success.' }
        format.json { render :show, status: :ok, location: @brochure }
      else
        format.html { render :edit }
        format.json { render json: @brochure.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /brochures/1
  # DELETE /brochures/1.json
  def destroy
    BrochureMember.where(brochure_id: @brochure.id )
    BrochureAnswer.where(brochure_id: @brochure.id )
    RelationBrochureScenarioMembers.where(brochure_id: @brochure.id )
    RelationBrochureScenarios.where(brochure_id: @brochure.id )
    @brochure.destroy
    respond_to do |format|
      format.html { redirect_to brochures_url, notice: 'Brosura a fost stearsa cu success.' }
      format.json { head :no_content }
    end
  end

  def fill_in
    @brochure = Brochure.find(params[:brochure_id])
    @preview = false
    @scenarios_ids = RelationBrochureScenarios.where(brochure_id: @brochure.id).pluck(:survey_id)
    @scenarios = Survey.includes(:questions => :options).order('questions.order ASC, options.order ASC').where(id: @scenarios_ids)
    @questions = Question.where(survey_id: @scenarios_ids).sort_by(&:order).group_by(&:survey_id)
    @answers = []
    @user = current_user

    respond_to do |format|
      format.html {render 'brochures/show'}
    end
  end

  def answer_brochure
    brochure_id = params["brochure_id"]
    user = current_user
    BrochureAnswer.where(brochure_id: brochure_id).where(user_id: user.id).delete_all
    multi_answers = params[:answer].select{|p| p.include?("multipleanswer_")} if params[:answer]
    answers = params[:answer].permit!.select{|p| !p.include?("multipleanswer_")} if params[:answer]

    multi_answers_final = {}

    multi_answers.each do |m_id, answer|
      question_id = m_id.split('_')[1].to_i
      append_value = (multi_answers_final[question_id].present? ? multi_answers_final[question_id] + ', ' : "")
      multi_answers_final[question_id] = append_value + answer.to_s
    end

    answers.each do |question_id, answer|
      BrochureAnswer.create({brochure_id: brochure_id, question_id: question_id, answer: answer, user_id: user.id})
    end
    multi_answers_final.each do |question_id, answer|
      BrochureAnswer.create({brochure_id: brochure_id, question_id: question_id, answer: answer, user_id: user.id})
    end

    BrochureMember.where(user_id: user.id).where(brochure_id: brochure_id).update_all(:answered => true)

    redirect_to brochure_members_path and return
  end

  def results
    @brochure = Brochure.find(params[:brochure_id])
    @scenarios_ids = RelationBrochureScenarios.where(brochure_id: @brochure.id).pluck(:survey_id)
    @scenarios = Survey.includes(:questions => :options).order('questions.order ASC, options.order ASC').where(id: @scenarios_ids)
    survey_questions = Question.where(survey_id: @scenarios_ids).sort_by(&:order)
    answers = BrochureAnswer.where(brochure_id: @brochure.id).group_by(&:question_id)
    nb_members_who_answered =  BrochureAnswer.where(brochure_id: @brochure.id).group_by(&:user_id).count
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

      [
          sq,
          answers[sq.id].present? ? answers_type(answers[sq.id], sq, nb_members_who_answered - skipped_answers, column_chart) : [],
          [nb_members_who_answered - skipped_answers, skipped_answers],
          column_chart.map{|a| [a.first, a.second.count]}
      ]
    end

  end


  def answers_type answers, question, total_answers, column_chart
    if question.question_type == "free_text"
      answers.sort_by(&:created_at).select { |a| a.answer.present? }

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
        answers_legend << [option.title, (nb_answers_per_option / total_answers.to_f * 100).round(2)]
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
        options = question.options
        options.each do |o|
          if (answer.answer + ', ').include?("#{o.title}, ") || answer.answer == o.title
            column_chart[o.title] << o.title
          end
        end
      end
    end

    column_chart
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_brochure
      @brochure = Brochure.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def brochure_params
      params.require(:brochure).permit(:title, :subdescription, :description, :sent_at, :brochures_nb)
    end

  def survey_brochure_params
    params.reject{|param| !param.include?("survey_") || params[param] == "0"}
  end
end
