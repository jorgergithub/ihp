class ChangeMinutesToBalance < ActiveRecord::Migration
  def change
    rename_column :clients, :minutes, :balance
  end
end
