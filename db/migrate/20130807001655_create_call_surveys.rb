class CreateCallSurveys < ActiveRecord::Migration
  def change
    create_table :call_surveys do |t|
      t.integer :call_id
      t.integer :survey_id

      t.timestamps
    end
  end
end
