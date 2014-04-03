class ChangeCreditsType < ActiveRecord::Migration
  def change
    change_column :clients, :balance, :decimal, precision: 8, scale: 2
    change_column :credits, :credits, :decimal, precision: 8, scale: 2
    change_column :packages, :credits, :decimal, precision: 8, scale: 2
  end
end
