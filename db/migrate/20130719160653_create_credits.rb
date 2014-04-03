class CreateCredits < ActiveRecord::Migration
  def change
    create_table :credits do |t|
      t.integer :client_id
      t.integer :minutes
      t.string :description

      t.timestamps
    end
  end
end
