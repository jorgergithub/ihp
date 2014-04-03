require "spec_helper"

describe PsychicsHelper do
  describe "#psychic_state" do
    let(:psychic) { FactoryGirl.build :psychic }
    it "returns available status" do
      psychic.stub(:current_state) { "available" } 
      expect(psychic_state psychic).to be_eql "I'm available"
    end

    it "returns busy status" do
      psychic.stub(:current_state) { "unavailable" } 
      expect(psychic_state psychic).to be_eql "I'm offline"
    end

    it "returns offline status" do
      psychic.stub(:current_state) { "on_a_call" } 
      expect(psychic_state psychic).to be_eql "I'm on a call"
    end
  end
end
