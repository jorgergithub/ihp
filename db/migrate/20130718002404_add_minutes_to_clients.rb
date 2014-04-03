class AddMinutesToClients < ActiveRecord::Migration
  def change
    add_column :clients, :minutes, :integer
  end
end
