class QuestionsController < ApplicationController
  require 'open-uri'

  def destroy
    Question.where(survey_id: params[:survey_id]).find(params[:question_id]).delete
    @survey = Survey.find(params[:survey_id])

    redirect_to edit_survey_path(id: params[:survey_id])
  end

  private

  def survey_params
    params.require(:survey).permit(:title, :description, :logo_id, :logo, :logo_instructions, :logo_on, :survey_params => [:title, :description])
  end
end
