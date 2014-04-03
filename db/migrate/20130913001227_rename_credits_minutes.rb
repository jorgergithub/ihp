class RenameCreditsMinutes < ActiveRecord::Migration
  def change
    rename_column :credits, :minutes, :credits
  end
end
