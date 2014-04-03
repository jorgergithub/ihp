class AddCallIdToReviews < ActiveRecord::Migration
  def change
    add_reference :reviews, :call, index: true
  end
end
