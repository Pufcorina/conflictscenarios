class CreateMemberQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :member_questions do |t|
      t.bigint :member_id
      t.bigint :question_id
      t.text :answer

      t.timestamps
    end
  end
end
