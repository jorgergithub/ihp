require "spec_helper"

describe PsychicApplication do
  describe "#approve!" do
    let(:psychic_application) { create(:psychic_application) }

    it "creates a new psychic with same attributes" do
      psychic_application.approve!

      psychic = Psychic.last

      expect(psychic.first_name).to eq psychic_application.first_name
      expect(psychic.last_name).to eq psychic_application.last_name
      expect(psychic.username).to eq psychic_application.username
      expect(psychic.email).to eq psychic_application.email
      expect(psychic.pseudonym).to eq psychic_application.pseudonym
      expect(psychic.address).to eq psychic_application.address
      expect(psychic.city).to eq psychic_application.city
      expect(psychic.country).to eq psychic_application.country
      expect(psychic.state).to eq psychic_application.state
      expect(psychic.postal_code).to eq psychic_application.postal_code
      expect(psychic.phone).to eq psychic_application.phone
      expect(psychic.cellular_number).to eq psychic_application.cellular_number
      expect(psychic.date_of_birth).to eq psychic_application.date_of_birth
      expect(psychic.emergency_contact).to eq psychic_application.emergency_contact
      expect(psychic.emergency_contact_number).to eq psychic_application.emergency_contact_number
      expect(psychic.us_citizen).to eq psychic_application.us_citizen
      expect(psychic.has_experience).to eq psychic_application.has_experience
      expect(psychic.experience).to eq psychic_application.experience
      expect(psychic.gift).to eq psychic_application.gift
      expect(psychic.explain_gift).to eq psychic_application.explain_gift
      expect(psychic.age_discovered).to eq psychic_application.age_discovered
      expect(psychic.reading_style).to eq psychic_application.reading_style
      expect(psychic.why_work).to eq psychic_application.why_work
      expect(psychic.friends_describe).to eq psychic_application.friends_describe
      expect(psychic.strongest_weakest_attributes).to eq psychic_application.strongest_weakest_attributes
      expect(psychic.how_to_deal_challenging_client).to eq psychic_application.how_to_deal_challenging_client
      expect(psychic.professional_goals).to eq psychic_application.professional_goals
      expect(psychic.how_did_you_hear).to eq psychic_application.how_did_you_hear
      expect(psychic.other).to eq psychic_application.other
      expect(psychic.resume.file.filename).to eq psychic_application.resume.file.filename
      expect(psychic.price).to eq psychic_application.price
      expect(psychic.user.time_zone).to eq psychic_application.time_zone
    end
  end
end
