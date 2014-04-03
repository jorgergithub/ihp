class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :order_id
      t.string :operation
      t.string :transaction_id
      t.boolean :success

      t.timestamps
    end
  end
end
