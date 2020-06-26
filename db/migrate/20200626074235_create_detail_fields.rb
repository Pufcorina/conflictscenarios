class CreateDetailFields < ActiveRecord::Migration[5.2]
  def change
    create_table :detail_fields do |t|
      t.string :name
      t.string :type
      t.integer :row
      t.integer :column

      t.timestamps
    end
  end
end
