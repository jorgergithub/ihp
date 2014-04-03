require "spec_helper"

describe Admin::PsychicsController do
  let(:wadmin) { create(:wadmin) }

  before {
    wadmin.confirm!
    sign_in wadmin
  }

  describe "POST create" do
    let(:params) { {"user"=>{"first_name"=>"Anderson", "last_name"=>"Polga", "username"=>"apolga", "email"=>"apolga@coury.com.br", "password"=>"[FILTERED]", "password_confirmation"=>"[FILTERED]", "psychic_attributes"=>{"phone"=>"", "featured"=>"0", "pseudonym"=>"Manchester", "ability_clairvoyance"=>"1", "ability_clairaudient"=>"0", "ability_clairsentient"=>"1", "ability_empathy"=>"0", "ability_medium"=>"0", "ability_channeler"=>"1", "ability_dream_analysis"=>"0", "tools_tarot"=>"0", "tools_oracle_cards"=>"1", "tools_runes"=>"0", "tools_crystals"=>"0", "tools_pendulum"=>"0", "tools_numerology"=>"1", "tools_astrology"=>"0", "specialties_love_and_relationships"=>"0", "specialties_career_and_work"=>"0", "specialties_money_and_finance"=>"1", "specialties_lost_objects"=>"0", "specialties_dream_interpretation"=>"0", "specialties_pet_and_animals"=>"0", "specialties_past_lives"=>"1", "specialties_deceased"=>"0", "style_compassionate"=>"0", "style_inspirational"=>"1", "style_straightforward"=>"0", "about"=>"Something", "price"=>"6.00", "address"=>"", "city"=>"", "country"=>"United States", "state"=>"", "postal_code"=>"", "cellular_number"=>"", "ssn"=>"", "date_of_birth"=>"", "emergency_contact"=>"", "emergency_contact_number"=>"", "resume_cache"=>"", "experience"=>"", "gift"=>"", "explain_gift"=>"", "age_discovered"=>"", "reading_style"=>"", "why_work"=>"", "friends_describe"=>"", "strongest_weakest_attributes"=>"", "how_to_deal_challenging_client"=>"", "specialties"=>"", "tools"=>"", "professional_goals"=>"", "how_did_you_hear"=>"", "other"=>""}}} }
    before { post :create, params}

    it "creates a new user with psychic role" do
      expect(assigns[:user].role).to eql("psychic")
    end
  end
end
