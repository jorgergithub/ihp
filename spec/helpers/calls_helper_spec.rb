require "spec_helper"

describe CallsHelper do
  describe "#calls_url_for" do
    it "appends a passed query string to the end" do
      url = calls_url_for("topup?Digits=10", "+17863500101")
      expect(url).to eql("/calls/topup.xml?From=%2B17863500101&Digits=10")
    end
  end

  describe "#price_to_phrase" do
    it "converts round dollars" do
      phrase = helper.price_to_phrase(30.00)
      expect(phrase).to eql("30 dollars")
    end

    it "converts dollars with cents" do
      phrase = helper.price_to_phrase(29.99)
      expect(phrase).to eql("29 dollars 99 cents")
    end

    it "converts dollars with multiples of 10 cents" do
      phrase = helper.price_to_phrase(6.5)
      expect(phrase).to eql("6 dollars 50 cents")
    end

    it "says one dollar in singular" do
      phrase = helper.price_to_phrase(1.25)
      expect(phrase).to eql("1 dollar 25 cents")
    end

    it "says one cent in singular" do
      phrase = helper.price_to_phrase(1.01)
      expect(phrase).to eql("1 dollar 1 cent")
    end

    it "omits the dollar part if <= 0.99" do
      phrase = helper.price_to_phrase(0.98)
      expect(phrase).to eql("98 cents")
    end
  end
end
