class AddBonusMinutesToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :bonus_minutes, :integer
  end
end
