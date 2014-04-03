class AddClientIdToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :client_id, :integer
  end
end
