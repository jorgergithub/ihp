class AddResumeToPsychicApplications < ActiveRecord::Migration
  def change
    add_column :psychic_applications, :resume, :string
  end
end
