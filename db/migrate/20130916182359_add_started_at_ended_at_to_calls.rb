class AddStartedAtEndedAtToCalls < ActiveRecord::Migration
  def change
    add_column :calls, :started_at, :datetime
    add_column :calls, :ended_at, :datetime
  end
end
