class AddInvoiceIdToCalls < ActiveRecord::Migration
  def change
    add_column :calls, :invoice_id, :integer
  end
end
