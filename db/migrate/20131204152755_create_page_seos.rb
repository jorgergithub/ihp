class CreatePageSeos < ActiveRecord::Migration
  def change
    create_table :page_seos do |t|
      t.string :page
      t.string :url
      t.string :title
      t.text :description
      t.text :keywords

      t.timestamps
    end
    add_index :page_seos, :url
  end
end
