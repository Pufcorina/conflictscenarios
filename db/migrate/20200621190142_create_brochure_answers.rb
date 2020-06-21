class CreateBrochureAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :brochure_answers do |t|
      t.bigint :user_id
      t.bigint :brochure_id
      t.bigint :question_id
      t.string :answer


      t.timestamps
    end

    add_column :brochures, :author, :string
  end
end
