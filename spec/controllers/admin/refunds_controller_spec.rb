require "spec_helper"

describe Admin::RefundsController do
  let(:order) { create(:order, status: "paid") }
  let(:wadmin) { create(:wadmin) }
  let(:order_refund) { double(:order_refund) }

  before {
    OrderRefund.stub(new: order_refund)
    order_refund.stub("process!" => true)

    wadmin.confirm!
    sign_in wadmin
  }

  describe "POST create" do
    before { post :create, order_id: order.id }

    it "redirects back to the psychic page" do
      expect(response).to redirect_to(admin_order_path(order))
    end

    it "sets a flash message" do
      expect(flash[:notice]).to eql("Order was successfully refunded.")
    end
  end
end
