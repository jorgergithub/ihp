class AddFeaturedToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :featured, :boolean, default: false
  end
end
