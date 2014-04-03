require "spec_helper"

describe Psychic do
  it { should belong_to :user }

  it { should have_many :calls }
  it { should have_many :reviews }
  it { should have_many :callbacks }

  it { should delegate(:email).to(:user).allowing_nil(true) }
  it { should delegate(:first_name).to(:user).allowing_nil(true) }
  it { should delegate(:full_name).to(:user).allowing_nil(true) }
  it { should delegate(:last_name).to(:user).allowing_nil(true) }
  it { should delegate(:username).to(:user).allowing_nil(true) }

  describe "validations" do
    it { should validate_presence_of(:pseudonym) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:phone) }
    it { should validate_as_phone_number(:phone) }
    it { should validate_uniqueness_of(:extension) }
  end

  describe "sign" do
    it "delegates sign to Sign class" do
      subject.date_of_birth = Sign::Aries.first_day
      expect(subject.sign).to be_eql Sign::Aries
    end
  end

  describe "#assign_extension" do
    it "assigns a random extension when creating" do
      RandomUtils.stub(:random_extension => "1234")

      subject.run_callbacks(:create)

      expect(subject.extension).to_not be_nil
      expect(subject.extension).to eq "1234"
    end
  end

  describe "#specialties" do
    it "returns the specialties as string" do
      subject.specialties_love_and_relationships = true
      subject.specialties_deceased = true

      expect(subject.specialties).to eq "love and relationships, deceased"
    end
  end

  describe "#alias_name" do
    it "returns pseudonym with first letter of last name" do
      subject.stub(:last_name => "Tracy")
      subject.pseudonym = "Jack"

      expect(subject.alias_name).to eq "Jack T"
    end
  end

  context "availability" do
    let(:psychic) { create(:psychic) }

    describe "#available?" do
      context "when there are no hour entries" do
        it "is false" do
          expect(psychic).to_not be_available
        end
      end

      context "when last hour entry has start action" do
        before { psychic.available! }
        it "is true" do
          expect(psychic).to be_available
        end
      end

      context "when status is unavailable" do
        before { psychic.unavailable! }
        it "is false" do
          expect(psychic).to_not be_available
        end
      end
    end

    describe "#available!" do
      before {
        psychic.available!
      }

      it "makes the psychic available" do
        expect(psychic).to be_available
      end

      it "sets the status field" do
        expect(psychic.status).to eql("available")
      end
    end

    describe "#on_a_call!" do
      before {
        psychic.available!
        psychic.on_a_call!
      }

      it "makes the psychic unavailable" do
        expect(psychic).to_not be_available
      end

      it "sets the status field" do
        expect(psychic.status).to eql("on_a_call")
      end
    end

    describe "#unavailable!" do
      before {
        psychic.available!
        psychic.unavailable!
      }

      it "makes the psychic unavailable" do
        expect(psychic).to_not be_available
      end

      it "sets the status field" do
        expect(psychic.status).to eql("unavailable")
      end
    end
  end

  describe "#status" do
    let(:psychic) { create(:psychic) }
    it "is unavailable by default" do
      expect(psychic.status).to eql("unavailable")
    end
  end

  describe "#can_callback?" do
    let(:psychic) { create(:psychic) }
    let(:user) { create(:user, create_as: "client") }
    let(:client) { user.client }

    before { client.balance = psychic.price * 10 }

    it "returns false if psychic is available" do
      psychic.stub(available?: true)
      expect(psychic.can_callback?(client)).to be_false
    end

    it "returns false if client balance is less than 10 minutes worth of psychic time" do
      client.balance = (psychic.price * 10) - 0.01
      expect(psychic.can_callback?(client)).to be_false
    end

    it "returns true if client balance is exactly 10 minutes worth of psychic time" do
      expect(psychic.can_callback?(client)).to be_true
    end

    it "returns true if client balance is more than 10 minutes worth of psychic time" do
      client.balance = (psychic.price * 10) + 0.01
      expect(psychic.can_callback?(client)).to be_true
    end
  end

  describe "#call" do
    let(:psychic) { build(:psychic, phone: "+13054502995") }
    let(:calls) { double(:calls) }
    let(:twilio_account) { double(:twilio_account) }

    before {
      calls.stub(:create)
      twilio_account.stub(calls: calls)
      psychic.stub(twilio_account: twilio_account)
    }

    it "calls the psychic number using Twilio" do
      psychic.call("URL")
      calls.should have_received(:create).with(from: "+17863295532", to: "+13054502995", url: "URL")
    end
  end

  describe "#total_calls_in_period" do
    let!(:psychic) { create(:psychic) }
    let!(:call) { create(:call, psychic: psychic) }
    let!(:invoice) { create(:invoice) }
    let!(:invoiced_call) { create(:call, psychic: psychic, invoice: invoice) }

    it "reports the number of uninvoiced calls" do
      expect(psychic.total_calls_in_period).to eql(1)
    end
  end

  describe "#total_minutes_in_period" do
    let!(:psychic) { create(:psychic) }
    let!(:call) { create(:call, psychic: psychic, original_duration: 10 * 60) }
    let!(:call2) { create(:call, psychic: psychic, original_duration: 15 * 60) }
    let!(:invoice) { create(:invoice) }
    let!(:invoiced_call) { create(:call, psychic: psychic, invoice: invoice, original_duration: 25 * 60) }

    it "reports the sum of the duration of uninvoiced calls" do
      expect(psychic.total_minutes_in_period).to eql(25)
    end
  end

  describe "#avg_minutes_per_call_in_period" do
    let!(:psychic) { create(:psychic) }
    let!(:call) { create(:call, psychic: psychic, original_duration: 10 * 60) }
    let!(:call2) { create(:call, psychic: psychic, original_duration: 15 * 60) }
    let!(:invoice) { create(:invoice) }
    let!(:invoiced_call) { create(:call, psychic: psychic, invoice: invoice, original_duration: 25 * 60) }

    it "reports the average minutes per call" do
      expect(psychic.avg_minutes_in_period).to eql(12)
    end
  end

  describe "#current_tier" do
    let(:psychic) { build(:psychic) }
    let(:tier) { double(:tier) }

    before do
      Tier.stub(for: tier)
      psychic.stub(total_minutes_in_period: 38)
      @tier = psychic.current_tier
    end

    it "returns the tier" do
      expect(@tier).to eql(tier)
    end

    it "queries the tier for the current total minutes" do
      expect(Tier).to have_received(:for).with(38)
    end
  end

  describe "#payout_percentage_in_period" do
    let(:psychic) { build(:psychic) }
    let(:tier) { double(:tier) }

    before do
      tier.stub(percent: 21)
      psychic.stub(current_tier: tier)
    end

    it "returns the tier's percentage" do
      expect(psychic.payout_percentage_in_period).to eql(21)
    end
  end

  describe ".add_specialty_filter" do
    context "when specialty exists" do
      let!(:psychic1) { create(:psychic, specialties_love_and_relationships: true) }
      let!(:psychic2) { create(:psychic, specialties_love_and_relationships: false) }
      let(:result) { Psychic.add_specialty_filter("love_and_relationships") }

      it "includes the psychic with specialty set" do
        expect(result).to include(psychic1)
      end

      it "excludes the psychic with specialty unset" do
        expect(result).not_to include(psychic2)
      end
    end

    context "when specialty doesn't exist" do
      it "raises an error" do
        expect { Psychic.add_specialty_filter("something") }.to raise_error
      end
    end
  end

  describe ".add_tool_filter" do
    context "when tool exists" do
      let!(:psychic1) { create(:psychic, tools_pendulum: true) }
      let!(:psychic2) { create(:psychic, tools_pendulum: false) }
      let(:result) { Psychic.add_tool_filter("pendulum") }

      it "includes the psychic with tool set" do
        expect(result).to include(psychic1)
      end

      it "excludes the psychic with tool unset" do
        expect(result).not_to include(psychic2)
      end
    end

    context "when specialty doesn't exist" do
      it "raises an error" do
        expect { Psychic.add_specialty_filter("something") }.to raise_error
      end
    end
  end

  describe "#estimated_wait" do
    let(:psychic) { create(:psychic) }

    context "when psychic is available" do
      context "with no callback queue" do
        it "returns 0" do
          expect(psychic.estimated_wait).to eql(0)
        end
      end

      context "when psychic has a callback queue of 2 people" do
        let(:client1) { create(:client) }
        let(:client2) { create(:client) }

        before {
          create(:callback, psychic: psychic, client: client1)
          create(:callback, psychic: psychic, client: client2)
        }

        it "returns 30 minutes" do
          expect(psychic.estimated_wait).to eql(30)
        end
      end

      context "when psychic has a completed callback" do
        let(:client1) { create(:client) }
        let(:client2) { create(:client) }
        let(:client3) { create(:client) }
        let!(:callback1) { create(:callback, psychic: psychic, client: client1, status: "active") }
        let!(:callback2) { create(:callback, psychic: psychic, client: client2, status: "active", expires_at: Time.now - 1.day) }
        let!(:callback3) { create(:callback, psychic: psychic, client: client3, status: "completed") }

        it "disregards completed and expired callbacks" do
          expect(psychic.estimated_wait).to eql(15)
        end
      end
    end

    context "when psychic is unavailable" do
      context "when psychic has been on calls and has a callback queue of 3 people" do
        let(:client1) { create(:client) }
        let(:client2) { create(:client) }
        let(:client3) { create(:client) }

        before {
          Timecop.freeze(Time.zone.parse("2013-09-28 00:00"))
          psychic.on_a_call!
          Timecop.freeze(Time.zone.parse("2013-09-28 00:12"))
          psychic.unavailable!

          create(:callback, client: client1, psychic: psychic)
          create(:callback, client: client2, psychic: psychic)
          create(:callback, client: client3, psychic: psychic)
        }

        after { Timecop.return }

        it "returns 45 minutes" do
          expect(psychic.estimated_wait).to eql(45)
        end
      end
    end

    context "when psychic is on a call" do
      before {
        Timecop.freeze(Time.zone.parse("2013-09-28 00:00"))
        psychic.on_a_call!
      }

      after { Timecop.return }

      context "for 3 minutes and 1 second and with 3 callbacks" do
        let(:client1) { create(:client) }
        let(:client2) { create(:client) }
        let(:client3) { create(:client) }

        before {
          create(:callback, psychic: psychic, client: client1)
          create(:callback, psychic: psychic, client: client2)
          create(:callback, psychic: psychic, client: client3)
        }

        it "returns 57 minutes" do
          Timecop.freeze(Time.zone.parse("2013-09-28 00:03:01"))
          expect(psychic.estimated_wait).to eql(57)
        end
      end

      context "for 1 minute and 10 seconds" do
        it "returns 14 minutes" do
          Timecop.freeze(Time.zone.parse("2013-09-28 00:01:10"))
          expect(psychic.estimated_wait).to eql(14)
        end
      end

      context "for 18 minute and 50 seconds" do
        it "returns 12 minutes" do
          Timecop.freeze(Time.zone.parse("2013-09-28 00:18:50"))
          expect(psychic.estimated_wait).to eql(12)
        end
      end
    end
  end

  describe "#current_call_length" do
    let(:psychic) { create(:psychic) }

    context "when psychic is available" do
      it "returns 0" do
        expect(psychic.current_call_length).to eql(0)
      end
    end

    context "when psychic is on a call" do
      before {
        Timecop.freeze(Time.zone.parse("2013-09-28 00:00"))
        psychic.on_a_call!
      }

      after { Timecop.return }

      context "when on a call for 3 minutes and 15 seconds" do
        before {
          Timecop.freeze(Time.zone.parse("2013-09-28 00:03"))
        }

        it "returns 3 minutes" do
          expect(psychic.current_call_length).to eql(3)
        end
      end
    end
  end

  describe "review_training!" do
    let(:psychic) { create(:psychic) }
    let(:training_item) { create(:training_item) }

    it "creates a new entry for the training" do
      expect { psychic.review_training!(training_item) }.to change { psychic.training_items.count }.by(1)
    end
  end

  describe "#reviewed_training?" do
    let(:psychic) { create(:psychic) }
    let(:training_item) { create(:training_item) }

    context "when psychic didn't review the training" do
      it "returns false" do
        expect(psychic.training_reviewed?(training_item)).to be_false
      end
    end

    context "when psychic reviewed the training" do
      before { psychic.review_training!(training_item) }

      it "returns true" do
        expect(psychic.training_reviewed?(training_item)).to be_true
      end
    end
  end

  describe "#training_complete?" do
    let(:psychic) { create(:psychic) }
    let!(:training_item1) { create(:training_item) }
    let!(:training_item2) { create(:training_item) }

    context "when no items are reviewed" do
      it "returns false" do
        expect(psychic.training_complete?).to be_false
      end
    end

    context "when one item isn't reviewed" do
      before {
        psychic.review_training!(training_item1)
      }

      it "returns false" do
        expect(psychic.training_complete?).to be_false
      end
    end

    context "when all the training items are reviewed" do
      before {
        psychic.review_training!(training_item1)
        psychic.review_training!(training_item2)
      }

      it "returns true" do
        expect(psychic.training_complete?).to be_true
      end
    end
  end

  describe "#disabled?" do
    context "when disabled is true" do
      let(:psychic) { create(:psychic, disabled: true) }

      it "is true" do
        expect(psychic).to be_disabled
      end
    end

    context "when disabled is false" do
      let(:psychic) { create(:psychic, disabled: false) }

      it "is false" do
        expect(psychic).to_not be_disabled
      end
    end
  end

  describe "#toggle_disabled!" do
    before { psychic.toggle_disabled! }

    context "when psychic is disabled" do
      let(:psychic) { create(:psychic, disabled: true) }

      it "enables it" do
        expect(psychic).not_to be_disabled
      end
    end

    context "when psychic is enabled" do
      let(:psychic) { create(:psychic, disabled: false) }

      it "disables it" do
        expect(psychic).to be_disabled
      end
    end
  end

  describe "#price_for" do
    let(:psychic) { create(:psychic, price: price) }
    let(:client) { double(:client) }

    context "psychic with a price less than or equal to $4" do
      let(:price) { 3 }

      context "new client" do
        before { client.stub(new_client?: true) }

        it "is $1" do
          expect(psychic.price_for(client)).to eql(1)
        end
      end

      context "existing client" do
        before { client.stub(new_client?: false) }

        it "is regular psychic price" do
          expect(psychic.price_for(client)).to eql(3)
        end
      end

      context "with no client" do
        let(:client) { nil }

        it "is regular psychic price" do
          expect(psychic.price_for(client)).to eql(3)
        end
      end
    end

    context "psychic with a price more than $4" do
      let(:price) { 4.5 }

      context "new client" do
        before { client.stub(new_client?: true) }

        it "is the regular psychic price" do
          expect(psychic.price_for(client)).to eql(4.5)
        end
      end

      context "existing client" do
        before { client.stub(new_client?: false) }

        it "is regular psychic price" do
          expect(psychic.price_for(client)).to eql(4.5)
        end
      end

      context "with no client" do
        let(:client) { nil }

        it "is regular psychic price" do
          expect(psychic.price_for(client)).to eql(4.5)
        end
      end
    end
  end

  describe "#special_price?" do
    let(:psychic) { create(:psychic, price: price) }
    let(:client) { double(:client) }

    context "when client is nil" do
      let(:price) { 4.5 }

      it "returns false" do
        expect(psychic.special_price?(nil)).to be_false
      end
    end

    context "when client is new" do
      before { client.stub(:new_client? => true) }

      context "when psychic price is $4 or less" do
        let(:price) { 4 }

        it "returns true" do
          expect(psychic.special_price?(client)).to be_true
        end
      end

      context "when psychic price is more than $4" do
        let(:price) { 4.5 }

        it "returns false" do
          expect(psychic.special_price?(nil)).to be_false
        end
      end
    end

    context "when client isn't new" do
      before { client.stub(:new_client? => false) }

      context "when psychic price is $4 or less" do
        let(:price) { 4 }

        it "returns false" do
          expect(psychic.special_price?(client)).to be_false
        end
      end

      context "when psychic price is more than $4" do
        let(:price) { 4.5 }

        it "returns false" do
          expect(psychic.special_price?(nil)).to be_false
        end
      end
    end
  end
end
