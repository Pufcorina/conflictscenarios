class CreateBrochureMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :brochure_members do |t|
      t.bigint :user_id
      t.bigint :brochure_id
      t.boolean :answered

      t.timestamps
    end
  end
end
