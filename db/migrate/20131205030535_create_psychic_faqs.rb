class CreatePsychicFaqs < ActiveRecord::Migration
  def change
    create_table :psychic_faqs do |t|
      t.references :psychic_faq_category, index: true
      t.text :question, null: false
      t.text :answer, null: false
      t.integer :order

      t.timestamps
    end

    add_foreign_key :psychic_faqs, :psychic_faq_categories, column: :psychic_faq_category_id
  end
end
