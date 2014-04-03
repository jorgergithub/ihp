require 'spec_helper'

describe Order do
  let(:package) { FactoryGirl.create(:package) }
  let(:order) { FactoryGirl.create(:order) }

  describe "saving the order" do
    it "sets the total to the sum of items" do
      order.items.build(description: "item 1", qty: 1, unit_price: 10, total_price: 10)
      order.items.build(description: "item 2", qty: 4, unit_price: 7.5, total_price: 30)
      order.save
      expect(order.total).to eql(40.0)
    end

    it "adds a package item if package_id is set" do
      order.package_id = package.id
      order.save

      expect(order.items.size).to eql(1)
    end
  end

  describe "#pay" do
    let(:stripe_client) { double(:stripe_client).as_null_object }
    let(:client) { order.client }
    let(:charge) { double(:charge, id: "charge_id") }

    before {
      order.package_id = package.id
      order.save

      client.update_attributes(balance: 0)
      client.stub(stripe_client: stripe_client)
      client.stub(:charge)
    }

    context "when not paid" do
      it "charges the order client" do
        client.should_receive(:charge).with(9.99, "Order ##{order.id}", order_id: order.id)
        order.pay
      end

      it "changes the order status to paid" do
        order.pay
        expect(order.status).to eql("paid")
      end

      it "adds credits to the client" do
        order.pay
        expect(client.reload.balance).to eql(package.credits)
      end
    end

    context "with a stripe token" do
      before {
        client.stub(:add_card_from_token)
        order.stripe_token = "token1234"
      }

      it "creates a new card for the client" do
        client.should_receive(:add_card_from_token).with("token1234")
        order.pay
      end

      it "clears the skype token" do
        order.pay
        expect(order.stripe_token).to be_nil
      end
    end

    context "when the order is paid" do
      it "raises an error" do
        order.status = "paid"
        expect { order.pay }.to raise_error
      end
    end
  end

  describe "#pay_with_paypal" do
    let!(:client) { user = create(:user, create_as: "client"); user.client }
    let!(:order) { create(:order, client: client, payment_method: "paypal") }
    let!(:package) { create(:package) }

    before do
      client.update_attributes balance: 8.60
      order.add_package_item(package)
      order.save
    end

    context "when payment_status is completed" do
      it "creates a new transaction" do
        expect {
          order.pay_with_paypal(payment_status: "Completed", txn_id: "TRANSACTION")
        }.to change {
          order.transactions.count
        }.by(1)
      end

      it "adds a new credit entry" do
        expect {
          order.pay_with_paypal(payment_status: "Completed", txn_id: "TRANSACTION")
        }.to change {
          client.credits.count
        }.by(1)
      end

      it "adds credits to the client" do
        expect {
          order.pay_with_paypal(payment_status: "Completed", txn_id: "TRANSACTION")
        }.to change {
          client.balance.to_f
        }.by(order.item.package.credits)
      end

      context "the credit entry" do
        before { order.pay_with_paypal("payment_status" => "Completed", "txn_id" => "TRANSACTION") }

        let(:credit) { client.credits.last }

        it "sets the correct amount of credits" do
          expect(credit.credits).to eql(order.item.package_credits)
        end
      end

      context "the transaction" do
        before { order.pay_with_paypal("payment_status" => "Completed", "txn_id" => "TRANSACTION") }

        let(:transaction) { order.transactions.last }

        it "is created for the order client" do
          expect(transaction.client).to eql(order.client)
        end

        it "has a charge operation" do
          expect(transaction.operation).to eql("charge")
        end

        it "has the paypal transaction id" do
          expect(transaction.transaction_id).to eql("TRANSACTION")
        end

        it "is successful" do
          expect(transaction).to be_success
        end

        it "has the order total" do
          expect(transaction.amount).to eql(order.total)
        end

        it "has PayPal as the card used" do
          expect(transaction.card).to eql("PayPal")
        end
      end
    end
  end

  describe "#paid?" do
    it "is true when status is paid" do
      order.status = "paid"
      expect(order).to be_paid
    end

    it "is false when status isn't paid" do
      expect(order).not_to be_paid
    end
  end

  describe "#add_package_item" do
    let(:package) { FactoryGirl.create(:package) }
    let(:item)    { order.reload.items.take }

    before {
      order.package_id = package.id
      order.save
    }

    it "creates a new OrderItem" do
      expect(order.items.size).to eql(1)
    end

    it "sets the package" do
      expect(item.package).to eql(package)
    end

    it "sets the quantity to 1" do
      expect(item.qty).to eql(1)
    end

    it "sets the unit price" do
      expect(item.unit_price).to eql(package.price)
    end

    it "sets the total price" do
      expect(item.total_price).to eql(package.price)
    end

    it "sets the description" do
      expect(item.description).to eql(package.name)
    end
  end

  describe "#package" do
    context "when order was one item" do
      before {
        order.package_id = package.id
        order.save
      }

      it "returns the first item package" do
        expect(order.package).to eql(order.items.first.package)
      end
    end

    context "when order has no items" do
      it "returns nil" do
        expect(order.package).to be_nil
      end
    end

    context "when order has more than one item" do
      before {
        order.items.create(description: "Something", qty: 1, unit_price: 10)
        order.items.create(description: "Something else", qty: 2, unit_price: 15)
      }

      it "returns nil" do
        expect(order.package).to be_nil
      end
    end
  end

  describe "#to_paypal" do
    let(:paypal) { double(:paypal) }
    let!(:package) { create(:package, name: "PACKAGE_NAME", price: 9.99) }

    subject { create(:order, total: 9.99) }

    before do
      subject.add_package_item(package)
      subject.save
    end

    it "creates a new PayPal object with the package name and total" do
      PayPal.should_receive(:new).with(subject.id, "PACKAGE_NAME", 9.99).and_return(paypal)
      expect(subject.to_paypal).to eql(paypal)
    end
  end

  describe "#paypal?" do
    context "when payment_method is paypal" do
      before { order.payment_method = "paypal" }
      it "is true" do
        expect(order).to be_paypal
      end
    end

    context "when payment_method is credit_card" do
      before { order.payment_method = "credit_card" }
      it "is false" do
        expect(order).to_not be_paypal
      end
    end
  end

  describe "#refundable?" do
    context "when not paid" do
      before { order.status = nil }

      it "is false" do
        expect(order).not_to be_refundable
      end
    end

    context "when paid" do
      before { order.status = "paid" }

      it "is true" do
        expect(order).to be_refundable
      end
    end

    context "when already refunded" do
      before { order.status = "refunded" }

      it "is false" do
        expect(order).not_to be_refundable
      end
    end

    context "when payment_method is paypal" do
      before { order.payment_method = "paypal" }

      it "is false" do
        expect(order).not_to be_refundable
      end
    end
  end
end
