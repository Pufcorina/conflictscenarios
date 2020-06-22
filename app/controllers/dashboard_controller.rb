class DashboardController < ApplicationController
  before_action :check_user_details

  def check_user_details
    @user = current_user
    if @user.try(:first_name).blank?
      flash[:error] = "Trebuie sa completezi detaliile profilului intai!"
      redirect_to edit_user_path(@user) and return
    end
  end

  def index
    @user = current_user
    @surveys = Survey.all
    @brochures = Brochure.all

    @completed_brochures = BrochureMember.where(user_id: @user.id).where(answered: true)
    @uncompleted_brochures = BrochureMember.where(user_id: @user.id).where(answered: false).order("created_at DESC")
    @brochures = Brochure.all.index_by(&:id)

    @total_submissions = BrochureAnswer.all.group_by{|r| [r[:user_id], r[:brochure_id]]}.count
  end
end
