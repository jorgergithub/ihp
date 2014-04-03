require 'spec_helper'

describe CallRefund do
  let!(:psychic) { FactoryGirl.create(:psychic, price: 5) }
  let!(:client)  { FactoryGirl.create(:client, ) }
  let!(:call)    { FactoryGirl.create(:call, client: client, psychic: psychic) }

  describe "refund call" do
    before do
      Rails.configuration.twilio = {account_sid: "account", auth_token: "token"}

      call.stub(:send_statistics)
      Call.stub(unprocessed: [call])

      VCR.use_cassette("twilio-call") do
        Call.process_calls
      end

      CallRefund.new(call).process!
    end

    it "balance" do
      expect(client.balance).to eql(60)
    end

    it "credits" do
      credit = Credit.where(description: "Refunded call \##{call.id} with #{call.psychic_alias_name}").first

      expect(credit.credits).to eql(10)
    end

    it "refunded" do
      expect(call.status).to eql("refunded")
    end
  end
end
