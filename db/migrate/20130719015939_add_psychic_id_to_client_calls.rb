class AddPsychicIdToClientCalls < ActiveRecord::Migration
  def change
    add_column :client_calls, :psychic_id, :integer
  end
end
