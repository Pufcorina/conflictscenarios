class AssignController < ApplicationController

  # GET /websites
  # GET /websites.json
  def index
    @specific_members = User.all
    @brochure = nil
    @preview = true
    @scenarios_ids = []
    @scenarios = []
    @questions = []
    @answers = []
    @user = current_user
  end

  def show

  end

  def search_members

  end

  def get_brochure
    @brochure = Brochure.find(params[:brochure_id])
    @preview = true
    @scenarios_ids = RelationBrochureScenarios.where(brochure_id: @brochure.id).pluck(:survey_id)
    @scenarios = Survey.includes(:questions => :options).order('questions.order ASC, options.order ASC').where(id: @scenarios_ids)
    @questions = Question.where(survey_id: @scenarios_ids).sort_by(&:order).group_by(&:survey_id)
    @answers = []
    @user = current_user
  end

  def assign_members
    brochure_id = params["brochure"]

    if params["specific_members"] == "on"
      members_ids = params["specific_members"].split(',')
    else
      members_ids = User.all.pluck(:id)
    end

    members_ids.each do |member|
      BrochureMember.create({user_id: member, brochure_id: brochure_id, answered: false})
    end

    flash[:notice] = 'Brosura trimisa!'
    redirect_to assign_path and return
  end



  private


    # Only allow a list of trusted parameters through.
    def security_params
      params.fetch(:security, {})
    end
end
