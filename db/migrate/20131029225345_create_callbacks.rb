class CreateCallbacks < ActiveRecord::Migration
  def change
    create_table :callbacks do |t|
      t.integer :psychic_id
      t.integer :client_id
      t.datetime :expires_at

      t.timestamps
    end
    add_index :callbacks, :psychic_id
    add_index :callbacks, :client_id
  end
end
