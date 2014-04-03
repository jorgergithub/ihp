class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :survey_id
      t.string :type
      t.string :text

      t.timestamps
    end
  end
end
