class AddPinToClients < ActiveRecord::Migration
  def change
    add_column :clients, :pin, :string
    remove_column :clients, :encrypted_pin
  end
end
