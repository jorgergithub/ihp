class AddPseudonymToPsychics < ActiveRecord::Migration
  def change
    add_column :psychics, :pseudonym, :string

    execute <<-SQL
      UPDATE psychics INNER JOIN users ON psychics.user_id = users.id
      SET psychics.pseudonym = users.first_name
    SQL
  end
end
