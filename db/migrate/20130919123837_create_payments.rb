class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :invoice_id
      t.string :transaction_id
      t.decimal :amount, precision: 8, scale: 2
    end
  end
end
