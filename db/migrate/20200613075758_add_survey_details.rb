class AddSurveyDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :surveys, :author, :string
    add_column :options, :aux_description, :string
  end
end
