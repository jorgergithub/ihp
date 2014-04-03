class AddPhoneToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :phone, :boolean
  end
end
