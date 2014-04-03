class RemoveReviewedAtFromTrainingItems < ActiveRecord::Migration
  def change
    remove_column :training_items, :reviewed_at, :string
  end
end
