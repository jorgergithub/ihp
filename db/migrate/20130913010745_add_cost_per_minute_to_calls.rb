class AddCostPerMinuteToCalls < ActiveRecord::Migration
  def change
    add_column :calls, :cost_per_minute, :decimal, precision: 8, scale: 2
  end
end
