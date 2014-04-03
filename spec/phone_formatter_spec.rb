require "spec_helper"
require "phone_formatter"

describe PhoneFormatter do
  describe ".format" do
    it "returns the formatted phone number" do
      expect(PhoneFormatter.format("+17863295532")).to eql("+1-786-329-5532")
    end
  end
end
