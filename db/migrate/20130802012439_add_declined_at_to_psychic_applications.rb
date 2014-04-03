class AddDeclinedAtToPsychicApplications < ActiveRecord::Migration
  def change
    add_column :psychic_applications, :declined_at, :timestamp
  end
end
