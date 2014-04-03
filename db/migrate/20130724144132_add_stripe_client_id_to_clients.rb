class AddStripeClientIdToClients < ActiveRecord::Migration
  def change
    add_column :clients, :stripe_client_id, :string
  end
end
