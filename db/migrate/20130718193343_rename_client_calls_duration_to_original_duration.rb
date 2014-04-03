class RenameClientCallsDurationToOriginalDuration < ActiveRecord::Migration
  def change
    rename_column :client_calls, :duration, :original_duration
  end
end
