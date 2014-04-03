require "spec_helper"

describe HoroscopesHelper do
  describe "#select_if_first" do
    it "returns select if index is zero" do
      expect(helper.select_if_first(0)).to be_eql "selected"
    end

    it "returns empty if index is not zero" do
      expect(helper.select_if_first(1, :prefix)).to be_eql ""
    end


    it "adds prefix to select if present" do
      expect(helper.select_if_first(0, :horoscope)).to be_eql "horoscope_selected"
    end
  end
end
