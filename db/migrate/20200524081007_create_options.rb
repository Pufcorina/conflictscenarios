class CreateOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :options do |t|
      t.bigint :question_id
      t.string :title
      t.integer :order
    end
  end
end
