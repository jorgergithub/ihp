require 'spec_helper'

describe PayPal do
  let(:paypal) { PayPal.new("REF", "DESCRIPTION", 100) }

  describe "#form" do
    subject { paypal.form }

    before do
      paypal.stub(encrypted: "ENCRYPTED")
    end

    it "returns a form with the encrypted values" do
      expect(subject).to include('<input type="hidden" name="encrypted" value="ENCRYPTED">')
    end
  end

  describe "#values" do
    subject { paypal.values }

    before do
      ENV["PAYPAL_ACCOUNT"] = "PAYPAL_ACCOUNT"
      ENV["PAYPAL_SUCCESS_URL"] = "PAYPAL_SUCCESS_URL"
      ENV["PAYPAL_CANCEL_URL"] = "PAYPAL_CANCEL_URL"
      ENV["PAYPAL_NOTIFY_URL"] = "PAYPAL_NOTIFY_URL"
      ENV["PAYPAL_APP_CERT_ID"] = "PAYPAL_APP_CERT_ID"
    end

    it "uses the right values" do
      expect(subject[:business]).to eql("PAYPAL_ACCOUNT")
      expect(subject[:cmd]).to eql("_xclick")
      expect(subject[:item_name]).to eql("DESCRIPTION")
      expect(subject[:amount]).to eql(100)
      expect(subject[:tax]).to eql(0)
      expect(subject[:no_note]).to eql(1)
      expect(subject[:no_shipping]).to eql(1)
      expect(subject[:currency_code]).to eql("USD")
      expect(subject[:custom]).to eql("REF")
      expect(subject[:return]).to eql("PAYPAL_SUCCESS_URL")
      expect(subject[:cancel_return]).to eql("PAYPAL_CANCEL_URL?reference=REF")
      expect(subject[:notify_url]).to eql("PAYPAL_NOTIFY_URL")
      expect(subject[:bn]).to eql("IHP_ST")
      expect(subject[:rm]).to eql("2")
      expect(subject[:invoice]).to eql("REF")
      expect(subject[:cert_id]).to eql("PAYPAL_APP_CERT_ID")
    end
  end
end
