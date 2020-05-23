class AddDetailsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :date_of_birth, :date
    add_column :users, :city, :string
    add_column :users, :country, :string
    add_column :users, :gender, :string


  end
end
