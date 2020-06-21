class DashboardController < ApplicationController
  def index
    @surveys = Survey.all
    @brochures = Brochure.all

    @user = current_user
    @completed_brochures = BrochureMember.where(user_id: @user.id).where(answered: true)
    @uncompleted_brochures = BrochureMember.where(user_id: @user.id).where(answered: false).order("created_at DESC")
    @brochures = Brochure.all.index_by(&:id)
  end
end
