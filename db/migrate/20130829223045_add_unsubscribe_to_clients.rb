class AddUnsubscribeToClients < ActiveRecord::Migration
  def change
    add_column :clients, :receive_newsletters, :boolean, default: true
    add_column :clients, :unsubscribe_key, :string
  end
end
