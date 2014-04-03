require "spec_helper"

describe User do
  describe "creating user as a clint" do
    let(:user) { create(:user, create_as: "client") }

    it "creates the client" do
      expect(user.client).to_not be_nil
    end

    it "creates the user with client role" do
      expect(user.role).to eql("client")
    end

    it "returns true to client?" do
      expect(user).to be_client
    end
  end

  describe "creating a psychic" do
    let(:user) { create(:user, create_as: "psychic") }

    it "creates the psychic" do
      expect(user.psychic).to_not be_nil
    end

    it "creates the user with psychic role" do
      expect(user.role).to eql("psychic")
    end

    it "returns true to psychic?" do
      expect(user).to be_psychic
    end
  end

  describe "#sign" do
    context "when user is client" do
      let(:subject) { create(:psychic, date_of_birth: Sign::Taurus.first_day).user }

      it "delegates sign to client" do
        expect(subject.sign).to be_eql Sign::Taurus
      end
    end
    
    context "when user is psychic" do
      let(:subject) { create(:client, birthday: Sign::Gemini.first_day).user }

      it "delegates sign to psychic" do
        expect(subject.sign).to be_eql Sign::Gemini
      end
    end

    context "when user isnt psychic or client" do
      let(:subject) { build :user }

      it "returns nil" do
        expect(subject.sign).to be_nil
      end
    end
  end
end
