class CreatePsychicTrainingItems < ActiveRecord::Migration
  def change
    create_table :psychic_training_items do |t|
      t.integer :psychic_id
      t.integer :training_item_id

      t.timestamps
    end
    add_index :psychic_training_items, :psychic_id
    add_index :psychic_training_items, :training_item_id
  end
end
