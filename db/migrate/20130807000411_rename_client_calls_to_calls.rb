class RenameClientCallsToCalls < ActiveRecord::Migration
  def change
    rename_table :client_calls, :calls
  end
end
