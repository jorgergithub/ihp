class RemoveLandlineFromPsychicApplication < ActiveRecord::Migration
  def change
    remove_column :psychic_applications, :landline_number, :string
    add_column :psychic_applications, :phone, :string
    remove_column :psychics, :landline_number, :string
  end
end
