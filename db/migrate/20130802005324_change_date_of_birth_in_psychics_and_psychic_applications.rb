class ChangeDateOfBirthInPsychicsAndPsychicApplications < ActiveRecord::Migration
  def change
    execute "UPDATE psychic_applications SET date_of_birth=NULL"
    execute "UPDATE psychics SET date_of_birth=NULL"
    change_column :psychic_applications, :date_of_birth, :date
    change_column :psychics, :date_of_birth, :date
  end
end
