require "spec_helper"

describe OrdersController do
  let(:user) { create(:user, create_as: "client") }
  let(:client) { user.client }
  let(:package) { create(:package, credits: 8.55) }

  before {
    user.confirm!
    sign_in user
  }

  describe "POST create" do
    context "with order params" do
      let(:attributes) { {order: {package_id: package.id}} }

      before do
        Order.any_instance.stub(:pay)
        post :create, attributes
      end

      it "creates the order with credit card as the payment method" do
        expect(assigns[:order].payment_method).to eql("credit_card")
      end
    end
  end

  describe "POST paypal" do
    context "with order params" do
      let(:paypal) { double(:paypal) }
      let(:attributes) { {order: {package_id: package.id}} }

      before do
        PayPal.stub(new: paypal)
        xhr :post, :paypal, attributes
      end

      it "renders the paypal form for the order" do
        expect(assigns[:paypal]).to eql(paypal)
      end

      it "creates the order with paypal as the payment method" do
        expect(assigns[:order].payment_method).to eql("paypal")
      end
    end
  end
end
