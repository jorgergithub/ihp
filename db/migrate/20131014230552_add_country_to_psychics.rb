class AddCountryToPsychics < ActiveRecord::Migration
  def change
    add_column :psychics, :country, :string
  end
end
