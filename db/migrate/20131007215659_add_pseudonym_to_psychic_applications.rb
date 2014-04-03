class AddPseudonymToPsychicApplications < ActiveRecord::Migration
  def change
    add_column :psychic_applications, :pseudonym, :string

    execute <<-SQL
      UPDATE psychic_applications SET pseudonym = first_name
    SQL
  end
end
