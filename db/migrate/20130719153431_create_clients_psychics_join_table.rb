class CreateClientsPsychicsJoinTable < ActiveRecord::Migration
  def change
    remove_column :clients, :favorite_psychic_id

    create_table :clients_psychics, :id => false do |t|
      t.integer :client_id
      t.integer :psychic_id
    end

    add_index :clients_psychics, [:client_id, :psychic_id]
  end
end
