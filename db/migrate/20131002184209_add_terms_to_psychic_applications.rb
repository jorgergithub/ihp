class AddTermsToPsychicApplications < ActiveRecord::Migration
  def change
    add_column :psychic_applications, :terms, :boolean
  end
end
