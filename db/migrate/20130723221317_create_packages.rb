class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :name
      t.integer :minutes
      t.decimal :price, precision: 8, scale: 2
      t.boolean :active

      t.timestamps
    end
  end
end
