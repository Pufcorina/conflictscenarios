class AssignController < ApplicationController

  # GET /websites
  # GET /websites.json
  def index
    @specific_members = User.all

  end

  def show

  end

  def search_members

  end



  private


    # Only allow a list of trusted parameters through.
    def security_params
      params.fetch(:security, {})
    end
end
