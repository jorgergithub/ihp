class CreatePsychicApplications < ActiveRecord::Migration
  def change
    create_table :psychic_applications do |t|
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :password
      t.string :email
      t.string :address
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :landline_number
      t.string :cellular_number
      t.string :ssn
      t.string :date_of_birth
      t.string :emergency_contact
      t.string :emergency_contact_number
      t.boolean :us_citizen
      t.boolean :has_experience
      t.text :experience
      t.string :gift
      t.text :explain_gift
      t.integer :age_discovered
      t.text :reading_style
      t.text :why_work
      t.text :friends_describe
      t.text :strongest_weakest_attributes
      t.text :how_to_deal_challenging_client
      t.text :specialties
      t.text :tools
      t.text :professional_goals
      t.string :how_did_you_hear
      t.text :other
      t.timestamp :approved_at
      t.integer :psychic_id

      t.timestamps
    end
  end
end
