class AddDeliveredToNewsletters < ActiveRecord::Migration
  def change
    add_column :newsletters, :delivered, :boolean
  end
end
