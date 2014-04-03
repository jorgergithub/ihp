class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :call_survey_id
      t.integer :question_id
      t.integer :option_id
      t.text :text

      t.timestamps
    end
  end
end
