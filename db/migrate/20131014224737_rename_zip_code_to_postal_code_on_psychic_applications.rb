class RenameZipCodeToPostalCodeOnPsychicApplications < ActiveRecord::Migration
  def change
    rename_column :psychic_applications, :zip_code, :postal_code
  end
end
