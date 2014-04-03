class CreatePsychicFaqCategories < ActiveRecord::Migration
  def change
    create_table :psychic_faq_categories do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
