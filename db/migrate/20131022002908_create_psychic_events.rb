class CreatePsychicEvents < ActiveRecord::Migration
  def change
    create_table :psychic_events do |t|
      t.references :psychic, index: true
      t.string :state

      t.timestamps
    end
  end
end
