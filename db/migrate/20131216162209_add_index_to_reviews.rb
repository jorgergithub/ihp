class AddIndexToReviews < ActiveRecord::Migration
  def change
    add_index :reviews, :psychic_id
  end
end
