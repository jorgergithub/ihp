require "spec_helper"

describe PsychicApplication do
  describe "validations" do
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:age_discovered) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:country) }
    it { should validate_presence_of(:date_of_birth) }
    it { should validate_presence_of(:experience) }
    it { should validate_presence_of(:explain_gift) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:friends_describe) }
    it { should validate_presence_of(:gift) }
    it { should validate_presence_of(:how_did_you_hear) }
    it { should validate_presence_of(:how_to_deal_challenging_client) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:postal_code) }
    it { should validate_presence_of(:professional_goals) }
    it { should validate_presence_of(:reading_style) }
    it { should validate_presence_of(:specialties) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:strongest_weakest_attributes) }
    it { should validate_presence_of(:time_zone) }
    it { should validate_presence_of(:tools) }
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:why_work) }

    it { should validate_as_phone_number(:cellular_number) }
    it { should validate_as_phone_number(:phone) }

    it { should allow_value(true).for(:us_citizen) }
    it { should allow_value(false).for(:us_citizen) }

    it { should allow_value(true).for(:has_experience) }
    it { should allow_value(false).for(:has_experience) }

    context "when persisted" do
      before do
        subject.stub(:persisted? => true)
      end

      it { should validate_presence_of(:price) }
    end

    context "when is a new record" do
      before do
        subject.stub(:persisted? => false)
      end

      it { should_not validate_presence_of(:price) }
    end
  end

  describe "#alias_name" do
    it "returns pseudonym with first letter of last name" do
      subject.last_name = "Tracy"
      subject.pseudonym = "Jack"

      expect(subject.alias_name).to eq "Jack T"
    end
  end
end
