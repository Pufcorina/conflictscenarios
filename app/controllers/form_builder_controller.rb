class FormBuilderController < ApplicationController
  def index

  end

  def new
    @titles = DetailForm.pluck(:title)
  end
end