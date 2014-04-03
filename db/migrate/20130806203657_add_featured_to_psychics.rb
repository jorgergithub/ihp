class AddFeaturedToPsychics < ActiveRecord::Migration
  def change
    add_column :psychics, :featured, :boolean
  end
end
