class AddAvatarIdToPsychics < ActiveRecord::Migration
  def change
    add_column :psychics, :avatar_id, :string
  end
end
