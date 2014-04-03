class AddPinToClient < ActiveRecord::Migration
  def change
    add_column :clients, :encrypted_pin, :string
  end
end
