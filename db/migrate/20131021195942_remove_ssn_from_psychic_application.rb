class RemoveSsnFromPsychicApplication < ActiveRecord::Migration
  def change
    remove_column :psychic_applications, :ssn
  end
end
