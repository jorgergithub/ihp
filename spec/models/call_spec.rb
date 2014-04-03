require 'spec_helper'

describe Call do
  it { should belong_to :client }
  it { should belong_to :invoice }
  it { should belong_to :psychic }

  it { should have_one(:call_survey).dependent(:destroy) }
  it { should have_one(:survey).through(:call_survey) }

  it { should have_many :credits }
  it { should have_many :reviews }

  it { should delegate(:alias_name).to(:psychic).allowing_nil(true).prefix(true) }
  it { should delegate(:full_name).to(:psychic).allowing_nil(true).prefix(true) }

  let!(:psychic) { FactoryGirl.create(:psychic, price: 4.50) }
  let!(:client)  { FactoryGirl.create(:client) }
  let!(:call)    { FactoryGirl.create(:call, client: client, psychic: psychic) }

  describe ".process_calls" do
    let!(:processed_call) { FactoryGirl.create(:processed_call, client: client) }

    before do
      Rails.configuration.twilio = {account_sid: "account", auth_token: "token"}

      call.stub(:send_statistics)
      Call.stub(unprocessed: [call])

      VCR.use_cassette("twilio-call") do
        Call.process_calls
      end
    end

    it "processes unprocessed calls" do
      expect(Call.find(call.id)).to be_processed
    end

    it "rounds duration" do
      expect(call.duration).to eql(2)
    end

    it "calculates the cost based on the psychic price" do
      expect(call.cost).to eql(9)
    end

    it "saves the cost per minute" do
      expect(call.cost_per_minute).to eql(4.50)
    end

    it "saves started_at" do
      expect(call.started_at.to_s).to eql("2013-07-17 19:50:32 -0400")
    end

    it "saves ended_at" do
      expect(call.ended_at.in_time_zone.to_s).to eql("2013-07-17 19:51:57 -0400")
    end

    it "saves the psychic rate used on the call" do
      expect(call.rate).to eql(4.5)
    end

    it "save fields correctly" do
      expect(call.date_created).to eql("Wed, 17 Jul 2013 23:50:32 +0000")
      expect(call.date_updated).to eql("Wed, 17 Jul 2013 23:51:57 +0000")
      expect(call.account_sid).to eql("AC4d5e48e4d4647262b5c4314e36e3d26e")
      expect(call.to).to eql("+15186335473")
      expect(call.from).to eql("+17863295532")
      expect(call.phone_number_sid).to eql("PN9523396e26f2d67f4375b7c67599a191")
      expect(call.status).to eql("completed")
      expect(call.start_time).to eql("Wed, 17 Jul 2013 23:50:32 +0000")
      expect(call.end_time).to eql("Wed, 17 Jul 2013 23:51:57 +0000")
      expect(call.original_duration).to eql("85")
      expect(call.price).to eql("-0.02000")
      expect(call.price_unit).to eql("USD")
      expect(call.direction).to eql("inbound")
    end

    it "discount duration from client credits" do
      client.reload
      expect(client.balance).to eql(51)
    end

    it "calls send_statistics" do
      expect(call).to have_received(:send_statistics)
    end
  end

  describe "#send_statistics" do
    it "sends call statistics to the client" do
      expect { call.send_statistics }.to change { Sidekiq::Extensions::DelayedMailer.jobs.size }.by(1)
    end
  end

  describe "#duration_str" do
    context "when minutes > 1" do
      let(:call) { Call.new(duration: 2) }
      it "returns 'minutes'" do
        expect(call.duration_str).to eql("2 minutes")
      end
    end

    context "when minutes = 1" do
      let(:call) { Call.new(duration: 1) }
      it "returns 'minute'" do
        expect(call.duration_str).to eql("1 minute")
      end
    end

    context "when minutes = 0" do
      let(:call) { Call.new(duration: 0) }
      it "returns 'no minutes'" do
        expect(call.duration_str).to eql("no minutes")
      end
    end
  end

  describe "#date" do
    it "returns the formatted date of the call" do
      expect(call.date).to eql("August  8, 2013")
    end
  end

  describe "#time" do
    it "returns the formatted" do
      expect(call.time).to eql("01:55 PM")
    end
  end

  describe "#survey_completed?" do
    let(:call) { create(:call) }
    context "when call survey doesn't have answers" do
      it "is false" do
        expect(call).not_to be_survey_completed
      end
    end

    context "when call survey has answers" do
      before { call.build_call_survey }
      it "is true" do
        expect(call).to be_survey_completed
      end
    end
  end

  describe "#process" do
    let(:client) { create(:client) }
    let(:psychic) { create(:psychic, price: 5) }
    let(:call) { build(:call, client: client, psychic: psychic) }
    let(:twilio_call) { double(:twilio_call).as_null_object }

    before {
      call.stub(twilio_call: twilio_call, duration: 5)
      call.stub(:save)
      call.stub(:send_statistics)
      client.stub(:discount_credits)
    }

    context "when client isn't new" do
      before {
        create(:call, client: client)
        call.process
      }

      it "charges normal psychic price per minute" do
        expect(call.cost.to_f).to eql(25.to_f)
      end

      it "saves the psychic price per minute" do
        expect(call.cost_per_minute.to_f).to eql(5.to_f)
      end
    end

    context "when client is new" do
      before { call.process }

      it "charges $1 per minute" do
        expect(call.cost.to_f).to eql(5.to_f)
      end

      it "saves the psychic price per minute" do
        expect(call.cost_per_minute.to_f).to eql(1.to_f)
      end
    end
  end

  describe "#profit" do
    let(:call) { create(:call, cost: 30, price: "2") }

    it "is the cost minus the price" do
      expect(call.profit).to eql(28)
    end
  end
end
