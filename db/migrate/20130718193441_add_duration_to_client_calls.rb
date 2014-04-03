class AddDurationToClientCalls < ActiveRecord::Migration
  def change
    add_column :client_calls, :duration, :integer
  end
end
