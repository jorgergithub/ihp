class AddCallSidsToCallbacks < ActiveRecord::Migration
  def change
    add_column :callbacks, :client_call_sid, :string
    add_column :callbacks, :psychic_call_sid, :string
  end
end
