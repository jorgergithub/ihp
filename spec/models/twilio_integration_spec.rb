require "spec_helper"
require "twilio"

describe TwilioIntegration do
  subject { Object.new.extend(TwilioIntegration) }

  describe "#create_call" do
    let(:twilio_account) { double(:twilio_account) }
    let(:calls) { double(:calls) }

    before {
      subject.stub(twilio_account: twilio_account)
      twilio_account.stub(calls: calls)
      calls.stub(:create)
    }

    it "uses twilio account to create a call" do
      subject.create_call("8888", "URL")
      expect(calls).to have_received(:create).with(from: "+17863295532", to: "8888", url: "URL")
    end
  end

  describe "#twilio_account" do
    let(:client) { double(:client) }
    let(:account) { double(:account) }

    before {
      TwilioHelper.stub(client: client)
      client.stub(account: account)
    }

    it "returns the account" do
      expect(subject.twilio_account).to eql(account)
    end
  end
end
