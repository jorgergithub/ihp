class AddCostToCall < ActiveRecord::Migration
  def change
    add_column :calls, :cost, :decimal, precision: 8, scale: 2
  end
end
