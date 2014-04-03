class CreateTiers < ActiveRecord::Migration
  def change
    create_table :tiers do |t|
      t.string :name
      t.integer :from
      t.integer :to

      t.timestamps
    end
  end
end
