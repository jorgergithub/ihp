class AddNamesToUser < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    remove_column :clients, :first_name
    remove_column :clients, :last_name
    remove_column :psychics, :first_name
    remove_column :psychics, :last_name
  end
end
