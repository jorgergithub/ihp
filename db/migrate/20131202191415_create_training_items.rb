class CreateTrainingItems < ActiveRecord::Migration
  def change
    create_table :training_items do |t|
      t.string :title
      t.string :file
      t.timestamp :reviewed_at

      t.timestamps
    end
  end
end
