class CreateBrochure < ActiveRecord::Migration[5.2]
  def change
    create_table :brochures do |t|
      t.string :title
      t.string :subdescription
      t.string :description
      t.date :sent_at
      t.integer :brochures_nb
    end
  end
end
