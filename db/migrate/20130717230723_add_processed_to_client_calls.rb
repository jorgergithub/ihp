class AddProcessedToClientCalls < ActiveRecord::Migration
  def change
    add_column :client_calls, :processed, :boolean
  end
end
