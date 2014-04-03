class CreateNewsletters < ActiveRecord::Migration
  def change
    create_table :newsletters do |t|
      t.string :title
      t.text :body
      t.timestamp :deliver_by

      t.timestamps
    end
  end
end
