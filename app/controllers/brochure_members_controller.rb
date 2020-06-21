class BrochureMembersController < ApplicationController

  def index
    @user = current_user

    brochures_ids= BrochureMember.where(user_id: @user.id).where(answered: false).pluck(:brochure_id)
    @brochures = Brochure.where(id: brochures_ids)
  end
end