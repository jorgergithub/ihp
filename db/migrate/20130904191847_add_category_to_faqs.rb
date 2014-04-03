class AddCategoryToFaqs < ActiveRecord::Migration
  def change
    add_reference :faqs, :category, index: true
    add_foreign_key :faqs, :categories, column: :category_id
  end
end
