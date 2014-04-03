require "spec_helper"

describe PhoneParser do
  describe "#localize" do
    it "returns the formatted phone number" do
      expect(subject.localize("+17863295532")).to eq "786-329-5532"
    end
  end

  describe "#parser" do
    it "returns phone number without dashes" do
      expect(subject.parse("786-329-5532")).to eq "+17863295532"
    end
  end
end
