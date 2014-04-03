class AddRateToCalls < ActiveRecord::Migration
  def change
    add_column :calls, :rate, :decimal, precision: 8, scale: 2
  end
end
