require "spec_helper"

describe User do
  it { should have_one(:admin).dependent(:destroy) }
  it { should have_one(:client).dependent(:destroy) }
  it { should have_one(:psychic).dependent(:destroy) }
  it { should have_one(:rep).dependent(:destroy) }

  describe "validations" do
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:time_zone) }

    it { should validate_uniqueness_of(:username) }
  end

  describe "#full_name" do
    it "joins first and last names" do
      subject.first_name = "Felipe"
      subject.last_name = "Coury"

      expect(subject.full_name).to eql("Felipe Coury")
    end
  end

  describe "#client?" do
    it "is false when role is nil" do
      subject.role = nil
      expect(subject).to_not be_client
    end

    it "is false when role is different from 'client'" do
      subject.role = "psychic"
      expect(subject).to_not be_client
    end

    it "is true when role is equal to 'client'" do
      subject.role = "client"
      expect(subject).to be_client
    end
  end

  describe "#psychic?" do
    it "is false when role is nil" do
      subject.role = nil
      expect(subject).to_not be_psychic
    end

    it "is false when role is different from 'psychic'" do
      subject.role = "client"
      expect(subject).to_not be_psychic
    end

    it "is true when role is equalt to 'psychic'" do
      subject.role = "psychic"
      expect(subject).to be_psychic
    end
  end
end
