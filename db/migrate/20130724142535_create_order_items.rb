class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.integer :order_id
      t.integer :package_id
      t.string :description
      t.integer :qty
      t.decimal :unit_price, precision: 8, scale: 2
      t.decimal :total_price, precision: 8, scale: 2

      t.timestamps
    end
  end
end
