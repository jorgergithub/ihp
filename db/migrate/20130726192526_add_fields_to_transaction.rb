class AddFieldsToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :amount, :decimal, precision: 8, scale: 2
    add_column :transactions, :card, :string
  end
end
