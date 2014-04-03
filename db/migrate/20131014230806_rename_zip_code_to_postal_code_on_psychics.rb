class RenameZipCodeToPostalCodeOnPsychics < ActiveRecord::Migration
  def change
    rename_column :psychics, :zip_code, :postal_code
  end
end
