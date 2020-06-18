class BrochuresController < ApplicationController
  before_action :set_brochure, only: [:show, :edit, :update, :destroy]

  # GET /brochures
  # GET /brochures.json
  def index
    @brochures = Brochure.all
  end

  # GET /brochures/1
  # GET /brochures/1.json
  def show
    @scenarios_ids = RelationBrochureScenarios.where(brochure_id: @brochure.id).pluck(:survey_id)
    @scenarios = Survey.includes(:questions => :options).order('questions.order ASC, options.order ASC').where(id: @scenarios_ids)
    @questions = Question.where(survey_id: @scenarios_ids).sort_by(&:order).group_by(&:survey_id)
    @answers = []
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

    if @brochure.save
      survey_brochure_params.each do |key, sb|
        RelationBrochureScenarios.create({brochure_id: @brochure.id, survey_id:sb})
      end
      respond_to do |format|
        format.html { redirect_to @brochure, notice: 'Brochure was successfully created.' }
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
        format.html { redirect_to @brochure, notice: 'Brochure was successfully updated.' }
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
    @brochure.destroy
    respond_to do |format|
      format.html { redirect_to brochures_url, notice: 'Brochure was successfully destroyed.' }
      format.json { head :no_content }
    end
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
