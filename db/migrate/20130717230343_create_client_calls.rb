class CreateClientCalls < ActiveRecord::Migration
  def change
    create_table :client_calls do |t|
      t.integer :client_id
      t.string :sid

      t.timestamps
    end
  end
end
