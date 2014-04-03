require "spec_helper"

describe Client do
  it { should belong_to :user }

  it { should have_many(:call_surveys).through(:calls) }
  it { should have_many(:calls) }
  it { should have_many(:cards).dependent(:destroy) }
  it { should have_many(:credits).dependent(:destroy) }
  it { should have_many(:orders) }
  it { should have_many(:phones).dependent(:destroy) }
  it { should have_many(:reviews) }
  it { should have_many(:transactions) }
  it { should have_many(:callbacks) }

  it { should have_and_belong_to_many(:favorite_psychics) }

  it { should delegate(:email).to(:user).allowing_nil(true) }
  it { should delegate(:first_name).to(:user).allowing_nil(true) }
  it { should delegate(:full_name).to(:user).allowing_nil(true) }
  it { should delegate(:last_name).to(:user).allowing_nil(true) }
  it { should delegate(:username).to(:user).allowing_nil(true) }

  let(:user)   { FactoryGirl.create(:user)}
  let(:client) { FactoryGirl.create(:client, user: user, pin: "1234", balance: 60) }

  describe "creating a client with pin" do
    let!(:client) do
      FactoryGirl.create(:client, user: user, pin: "1234")
    end

    it "saves the pin number" do
      expect(client.reload.pin).to eql("1234")
    end
  end

  describe "deleting a client" do
    context "with a phone" do
      let!(:user) { FactoryGirl.create(:user, create_as: "client") }
      let!(:client) { user.client }
      let!(:phone) { client.phones.first }

      it "deletes the phone" do
        user.destroy
        expect { ClientPhone.find(phone.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "#pin" do
    it "saves the pin" do
      client.reload
      expect(client.pin).not_to be_nil
      expect(client.pin).not_to be_empty
    end

    it "allows resetting the pin" do
      client.reload
      client.pin = "1232"
      client.save
      expect(client.valid_pin?("1232")).to be_true
    end

    it "allows 2 clients with same pin" do
      create(:client, pin: "1234")
      create(:client, pin: "1234")
    end
  end

  describe "#set_random_pin" do
    let(:client) { FactoryGirl.create(:client, user: user) }

    before { RandomUtils.stub(digits_s: "1234") }

    it "creates a random PIN number" do
      expect(client.pin).to eql("1234")
    end
  end

  describe "#pin?" do
    let(:client) { Client.create(user: user) }

    context "when no pin is set" do
      it "is false" do
        client.pin = nil
        expect(client).to_not be_pin
      end
    end

    context "when pin is set" do
      it "is true" do
        client.pin = "1234"
        expect(client).to be_pin
      end
    end
  end

  describe "#valid_pin?" do
    it "is true when PIN matches" do
      expect(client.valid_pin?("1234")).to be_true
    end

    it "is false when PIN mismatches" do
      expect(client.valid_pin?("1233")).to be_false
    end
  end

  describe "#add_credits" do
    context "with an user with no credits" do
      before do
        client.update_attributes(balance: nil)
        client.add_credits(3.41)
      end

      it "removes credits" do
        expect(client.balance).to eql(3.41)
      end
    end

    context "with an user with credits" do
      before { client.add_credits(12.29) }

      it "removes credits" do
        expect(client.balance.to_f).to eql(72.29)
      end

      it "saves the credits" do
        client.reload
        expect(client.balance.to_f).to eql(72.29)
      end
    end

    context "with a string as parameter" do
      it "works" do
        client.add_credits("10")
        expect(client.balance).to eql(70)
      end
    end
  end

  describe "#remove_credits" do
    context "with an user with no credits" do
      before do
        client.update_attributes(balance: nil)
      end

      it "removes credits" do
        client.remove_credits(3.41)
        expect(client.balance).to eql -3.41
      end
    end

    context "with an user with credits" do
      before do
        client.update_attributes(balance: nil)
        client.add_credits(12.29)
      end

      it "removes credits" do
        client.remove_credits(5.24)
        expect(client.balance.to_f).to eq 7.05
      end
    end
  end

  describe "#discount_credits" do
    let(:call)   { FactoryGirl.create(:call, cost: 4.55) }
    let(:credit) { client.credits.first }

    context "with an user with no credits" do
      before do
        client.update_attributes(balance: nil)
        client.discount_credits(call)
      end

      it "removes credits" do
        expect(client.balance).to eql(-4.55)
      end

      it "records the credit summary" do
        expect(credit.description).to eql("Call with Jack D")
        expect(credit.credits).to eql(-4.55)
      end
    end

    context "with an user with credits" do
      before { client.discount_credits(call) }

      it "removes credits" do
        expect(client.balance).to eql(55.45)
      end

      it "saves the credits" do
        client.reload
        expect(client.balance).to eql(55.45)
      end
    end

    context "with an user with zero credits" do
      pending
    end
  end

  describe "#seconds" do
    let(:psychic) { build(:psychic, price: 4.50) }

    context "when client has a balance and psychic has a price" do
      let(:client) { build(:client) }

      before { client.stub(minutes_with: 3) }

      it "is the seconds representation of number of minutes the client can talk to the psychic" do
        expect(client.seconds(psychic)).to eql(3 * 60)
      end
    end

    context "when balance is nil" do
      it "is zero" do
        expect(Client.new(balance: nil).seconds(psychic)).to eql(0)
      end
    end
  end

  describe "#stripe_client" do
    let(:stripe_client) { double("stripe_client").as_null_object }

    context "when stripe_client_id is nil" do
      let(:client) { FactoryGirl.create(:client) }

      context "when omitting reload" do
        before {
          stripe_client.stub(id: "abc123")
          Stripe::Customer.stub(:create => stripe_client)
        }

        it "creates a new customer" do
          expect(client.stripe_client).to eql(stripe_client)
        end

        it "creates the new customer with a description" do
          desc = { description: "#{client.id} - #{client.full_name} (#{client.username})" }
          Stripe::Customer.should_receive(:create).with(hash_including(desc))
          client.stripe_client
        end

        it "saves the new client id" do
          client.stripe_client
          expect(client.stripe_client_id).to eql("abc123")
        end
      end
    end

    context "when stripe_client_id isn't nil" do
      let(:client) { FactoryGirl.create(:client, stripe_client_id: "abc123") }

      before { Stripe::Customer.stub(retrieve: stripe_client) }

      it "returns the stripe client" do
        expect(client.stripe_client).to eql(stripe_client)
      end

      context "when omitting reload" do
        it "caches the stripe client instance" do
          Stripe::Customer.should_receive(:retrieve).once
          client.stripe_client
          client.stripe_client
        end
      end

      context "when reload is true" do
        it "doesn't cache the stripe client instance" do
          Stripe::Customer.should_receive(:retrieve).twice
          client.stripe_client
          client.stripe_client(true)
        end
      end
    end
  end

  describe "#charge" do
    let(:stripe_client) { double(:stripe_client, id: "abc123") }
    let(:charge) { double(:charge, id: "charge_id") }
    let(:transaction) { client.transactions.take }

    before {
      client.stub(stripe_client: stripe_client)
      Stripe::Charge.stub(:create => charge)
    }

    context "when charge succeeds" do
      it "charges the stripe client id" do
        info = { customer: "abc123" }
        Stripe::Charge.should_receive(:create).with(hash_including(info))
        client.charge(100, "something")
      end

      it "charges the given amount" do
        info = { amount: 10002 }
        Stripe::Charge.should_receive(:create).with(hash_including(info))
        client.charge(100.02, "something")
      end

      it "charges with the given description" do
        info = { description: "something" }
        Stripe::Charge.should_receive(:create).with(hash_including(info))
        client.charge(100.02, "something")
      end

      it "charges in USD" do
        info = { currency: "usd" }
        Stripe::Charge.should_receive(:create).with(hash_including(info))
        client.charge(100.02, "something")
      end

      it "returns the charge object" do
        expect(client.charge(100, "something")).to eql(charge)
      end

      describe "transaction" do
        before { client.charge(100, "something") }

        it "creates one transaction" do
          expect(client.transactions.size).to eql(1)
        end

        it "sets operation" do
          expect(transaction.operation).to eql("charge")
        end

        it "sets success" do
          expect(transaction).to be_success
        end

        it "sets the charge id" do
          expect(transaction.transaction_id).to eql("charge_id")
        end
      end
    end

    context "when there are charging errors" do
      before {
        error = "(Status 402) Cannot charge a customer that has no active card"
        exception = Stripe::CardError.new(error, "param", "code")
        Stripe::Charge.stub(:create).and_raise(exception)
      }

      it "raises the error" do
        expect {
          client.charge(100, "something")
        }.to raise_error(Stripe::CardError)
      end
    end
  end

  describe "#add_card_from_token" do
    let(:card) { double(:card) }
    let(:stripe_client) { double(:stripe_client).as_null_object }
    let(:stripe_cards) { double(:stripe_cards).as_null_object }

    before {
      client.stub(stripe_client: stripe_client)
      client.stub(:save_cards)
      stripe_client.stub(cards: stripe_cards)
    }

    it "updates the card" do
      stripe_client.should_receive(:card=).with("tok_2FgDgRXOFFXjtW")
      client.add_card_from_token("tok_2FgDgRXOFFXjtW")
    end

    it "saves the card" do
      stripe_client.should_receive(:save)
      client.add_card_from_token("tok_2FgDgRXOFFXjtW")
    end

    it "saves the customer cards" do
      client.should_receive(:save_cards)
      client.add_card_from_token("tok_2FgDgRXOFFXjtW")
    end
  end

  describe "#save_cards" do
    let(:stripe_card) { double(:stripe_card) }
    let(:stripe_client) { double(:stripe_client, cards: [stripe_card]) }

    let(:card) { client.reload.cards.take }

    before {
      stripe_card.stub(id: "cc_2G2L06vvQS1BKY")
      stripe_card.stub(to_hash: {
        id: "cc_2G2L06vvQS1BKY",
        object: "card",
        last4: "4242",
        type: "Visa",
        exp_month: 7,
        exp_year: 2014,
        fingerprint: "3DdmECgaaL5RtYzn",
        customer: "cus_2Fzi6yfxE0y7bB",
        country: "US",
        address_city: nil,
        cvc_check: "pass"})

      client.cards.create
      client.stub(stripe_client: stripe_client)
    }

    it "reloads the client" do
      client.should_receive(:stripe_client).with(true)
      client.save_cards
    end

    context "after saving the card" do
      before { client.save_cards }

      it "creates a new card" do
        expect(client.cards.size).to eql(1)
      end

      it "assigns stripe_id" do
        expect(card.stripe_id).to eql("cc_2G2L06vvQS1BKY")
      end

      it "assigns last4" do
        expect(card.last4).to eql("4242")
      end

      it "assigns type" do
        expect(card.type).to eql("Visa")
      end

      it "assigns exp_month" do
        expect(card.exp_month).to eql(7)
      end

      it "assigns exp_year" do
        expect(card.exp_year).to eql(2014)
      end

      it "assigns country" do
        expect(card.country).to eql("US")
      end

      it "assigns address_city" do
        expect(card.address_city).to be_nil
      end
    end
  end

  describe "#unsubscribe_from_newsletters" do
    let(:client) { create(:client, receive_newsletters: true) }
    before { client.unsubscribe_from_newsletters }
    it "sets receive_newsletters to false" do
      expect(client).to_not be_receive_newsletters
    end
  end

  describe "setting unsubscribe key" do
    let(:client) { create(:client) }
    it "sets when creating" do
      expect(client.unsubscribe_key).to_not be_nil
    end

    it "doesn't reset when saving" do
      key = client.unsubscribe_key
      client.receive_newsletters = false
      client.save
      expect(client.unsubscribe_key).to eql(key)
    end
  end

  describe "#minutes_with" do
    let(:psychic) { create(:psychic, price: 6.50) }
    let(:client)  { create(:client, balance: 81.25)}

    context "when client is not new" do
      before { client.stub(:new_client? => false) }

      it "calculates number of minutes you can talk with a psychic" do
        expect(client.minutes_with(psychic)).to eql(12)
      end
    end

    context "when client is new" do
      before { client.stub(:new_client? => true) }

      it "considers the special offer" do
        expect(client.minutes_with(psychic)).to eql(81)
      end
    end
  end

  describe "#call" do
    let(:client) { create(:client) }
    let(:phone) { double(:phone, number: "12345") }
    let(:phone2) { double(:phone, number: "8888") }

    before {
      client.stub(:create_call)
      client.stub(phones: [phone, phone2])
    }

    it "creates the call with client's first phone number" do
      client.call("URL")
      expect(client).to have_received(:create_call).with("12345", "URL")
    end
  end

  describe "#formatted_balance" do
    context "when user has credit" do
      let(:client) { create(:client, balance: 150) }

      it "returns the credit" do
        expect(client.formatted_balance).to eql(150)
      end
    end

    context "when user has no credit" do
      let(:client) { create(:client, balance: nil) }

      it "returns 0" do
        expect(client.formatted_balance).to eql(0)
      end
    end
  end

  describe "#new_client" do
    let(:client) { create(:client) }

    context "when user has no calls" do
      it "returns true" do
        expect(client.new_client?).to be_true
      end
    end

    context "when user has only an incomplete call" do
      let!(:call) { create(:call, client: client, status: nil) }

      it "returns true" do
        expect(client.new_client?).to be_true
      end
    end

    context "when user has complete calls" do
      let!(:call) { create(:call, client: client, status: "completed") }

      it "returns false" do
        expect(client.new_client?).to be_false
      end
    end
  end

  describe "#enough_balance_for" do
    let(:client) { create(:client) }
    let(:psychic) { create(:psychic, price: 6) }

    context "when client's balance is enough for one minute with the psychic" do
      before { client.stub(balance: 6) }

      it "is true" do
        expect(client.enough_balance_for(psychic)).to be_true
      end
    end

    context "when client's balance is not enough for one minute with the psychic" do
      before { client.stub(balance: 5.9) }

      it "is false" do
        expect(client.enough_balance_for(psychic)).to be_false
      end
    end
  end
end
