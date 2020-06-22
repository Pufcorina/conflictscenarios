class BrochureMembersController < ApplicationController
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
    @brochures_member = BrochureMember.where(user_id: @user.id).where(answered: false).index_by(&:brochure_id)
    brochures_ids= BrochureMember.where(user_id: @user.id).where(answered: false).pluck(:brochure_id)
    @brochures = Brochure.where(id: brochures_ids)
  end
end