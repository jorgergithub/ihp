class ChangeActiveFromPackages < ActiveRecord::Migration
  def change
    change_column :packages, :active, :boolean, :default => true
  end
end
