class AddTopSpecialityToPsychics < ActiveRecord::Migration
  def change
    add_column :psychics, :top_speciality, :string
  end
end
