class SecuritiesController < ApplicationController

  # GET /websites
  # GET /websites.json
  def index
    @page = nil
  end

  def show

  end



  private


    # Only allow a list of trusted parameters through.
    def security_params
      params.fetch(:security, {})
    end
end
