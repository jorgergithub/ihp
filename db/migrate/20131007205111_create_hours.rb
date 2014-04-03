class CreateHours < ActiveRecord::Migration
  def change
    create_table :hours do |t|
      t.references :psychic, index: true
      t.string :action

      t.timestamps
    end
  end
end
