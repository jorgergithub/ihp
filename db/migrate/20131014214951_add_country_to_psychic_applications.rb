class AddCountryToPsychicApplications < ActiveRecord::Migration
  def change
    add_column :psychic_applications, :country, :string
  end
end
