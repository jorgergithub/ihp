class RenamePackagesMinutes < ActiveRecord::Migration
  def change
    rename_column :packages, :minutes, :credits
  end
end
