class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :client_id
      t.decimal :total, precision: 8, scale: 2
      t.string :status

      t.timestamps
    end
  end
end
