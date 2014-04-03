class CreateCustomerServiceRepresentatives < ActiveRecord::Migration
  def change
    create_table :customer_service_representatives do |t|
      t.integer :user_id
      t.string :phone

      t.timestamps
    end
  end
end
