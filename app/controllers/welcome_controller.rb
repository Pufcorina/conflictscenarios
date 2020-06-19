class WelcomeController < ApplicationController
  def index
    @surveys = Survey.all
    @brochures = Brochure.all
  end
end
