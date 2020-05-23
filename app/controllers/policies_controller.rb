class PoliciesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  # GET /websites
  # GET /websites.json
  def privacy_policy
    @policy = Policy.where(name: 'privacy_policy').first
    respond_to do |format|
      format.html {render 'policies/show'}
    end
  end

  def terms_and_conditions
    @policy = Policy.where(name: 'terms_and_conditions').first
    respond_to do |format|
      format.html {render 'policies/show'}
    end
  end

  def cookie_policy
    @policy = Policy.where(name: 'cookie_policy').first
    respond_to do |format|
      format.html {render 'policies/show'}
    end
  end

  def edit
    @policy = Policy.find(params[:id])
  end

  def update
    @policy = Policy.find(params[:id])
    @policy.update_attributes(policy_params)

    if @policy.name == 'privacy_policy'
      redirect_to website_privacy_policy_path and return
    elsif @policy.name == 'terms_and_conditions'
      redirect_to website_terms_and_conditions_path and return
    else
      redirect_to website_cookies_path and return
    end
  end

  private


  # Only allow a list of trusted parameters through.
  def policy_params
    params.require(:policy).permit( :name, :content, :id)
  end
end
