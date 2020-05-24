class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.string :title
      t.bigint :survey_id
      t.string :question_type
      t.integer :order
      t.boolean :required
      t.text :description
      t.text :options

      t.timestamps
    end
  end
end
