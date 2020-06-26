class CreateDetailForms < ActiveRecord::Migration[5.2]
  def change
    create_table :detail_forms do |t|
      t.string :title

      t.timestamps
    end
  end
end
