class CreateSurveys < ActiveRecord::Migration[5.2]
  def change
    create_table :surveys do |t|
      t.string :title
      t.text :description
      t.datetime :send_at
      t.bigint :user_id

      t.timestamps
    end
  end
end
