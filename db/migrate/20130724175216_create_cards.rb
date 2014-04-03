class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.integer :client_id
      t.string :last4
      t.string :type
      t.integer :exp_month
      t.integer :exp_year
      t.string :country
      t.string :address_city
      t.string :stripe_id

      t.timestamps
    end
  end
end
