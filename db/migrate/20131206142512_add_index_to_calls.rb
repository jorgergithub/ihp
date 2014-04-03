class AddIndexToCalls < ActiveRecord::Migration
  def change
    add_index :calls, :sid
    add_index :calls, :client_id
    add_index :calls, :psychic_id
  end
end
