class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :psychic_id
      t.integer :total_minutes
      t.integer :number_of_calls
      t.decimal :avg_minutes, precision: 8, scale: 2
      t.decimal :minutes_payout, precision: 8, scale: 2
      t.decimal :bonus_payout, precision: 8, scale: 2
      t.integer :tier_id

      t.timestamps
    end
  end
end
