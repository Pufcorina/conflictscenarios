class DashboardController < ApplicationController
  def index
    @surveys = Survey.all
    @brochures = Brochure.all

    @user = current_user
    @completed_brochures = BrochureMember.where(user_id: @user.id).where(answered: true)
    @uncompleted_brochures = BrochureMember.where(user_id: @user.id).where(answered: false).order("created_at DESC")
    @brochures = Brochure.all.index_by(&:id)

    @total_submissions = BrochureAnswer.all.group_by{|r| [r[:user_id], r[:brochure_id]]}.count
  end
end
