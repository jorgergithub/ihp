class AddAvailableToCustomerServiceRepresentative < ActiveRecord::Migration
  def change
    add_column :customer_service_representatives, :available, :boolean
  end
end
