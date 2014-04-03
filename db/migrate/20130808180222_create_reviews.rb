class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :psychic_id
      t.integer :client_id
      t.integer :rating
      t.text :text

      t.timestamps
    end
  end
end
