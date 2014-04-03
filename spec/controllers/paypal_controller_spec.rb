require "spec_helper"

describe PaypalController do
  context "for a guest" do
    it "allows POST /paypal/callback" do
      post :callback
      expect(response.status).to eql(200)
    end
  end

  context "for a logged user" do
    let(:user) { create(:user, create_as: "client") }
    let(:client) { user.client }
    let(:package) { create(:package, credits: 50) }
    let(:order) { create(:order, client: client, total: 50) }
    let!(:order_item) { create(:order_item, order: order, package: package) }

    before {
      user.confirm!
      sign_in user
    }

    describe "POST callback" do
      before { client.update_attributes(balance: 10) }

      context "when the payment was completed" do
        it "renders 200" do
          post :callback, callback_hash(order)
          expect(response.status).to eql(200)
        end

        it "adds credits to the user" do
          expect {
            post :callback, callback_hash(order)
          }.to change{ client.reload.balance.to_f }.by(50)
        end

        it "creates a new transaction" do
          expect {
            post :callback, callback_hash(order)
          }.to change{ client.transactions.count }.by(1)
        end

        it "creates a new credit entry" do
          expect {
            post :callback, callback_hash(order)
          }.to change{ client.credits.count }.by(1)
        end
      end

      context "when the payment was not completed" do
        let(:attributes) { callback_hash(order, "payment_status" => "Pending") }

        it "renders 200" do
          post :callback, attributes
          expect(response).to be_ok
        end

        it "doesn't add credits to the user" do
          expect {
            post :callback, attributes
          }.to_not change{ client.reload.balance.to_f }
        end
      end
    end

    def callback_hash(order, overrides={})
      {
                        "mc_gross" => "50.00",
                         "invoice" => order.id,
          "protection_eligibility" => "Ineligible",
                        "payer_id" => "MQ4LVXEPWQN2J",
                             "tax" => "0.00",
                    "payment_date" => "18:08:07 Oct 17, 2013 PDT",
                  "payment_status" => "Completed",
                         "charset" => "windows-1252",
                      "first_name" => "Felipe",
                          "mc_fee" => "1.75",
                  "notify_version" => "3.7",
                          "custom" => "10",
                    "payer_status" => "verified",
                        "business" => "felipe.coury-facilitator@gmail.com",
                        "quantity" => "1",
                     "verify_sign" => "An5ns1Kso7MWUdW4ErQKJJJ4qi4-A6aiL0f6-lxJyGaQahD5s6OA1FbG",
                     "payer_email" => "felipecoury+iheart@gmail.com",
                          "txn_id" => "1XT43486JF537453V",
                    "payment_type" => "instant",
             "payer_business_name" => "Felipe Coury's Test Store",
                       "last_name" => "Coury",
                  "receiver_email" => "felipe.coury-facilitator@gmail.com",
                     "payment_fee" => "1.75",
                     "receiver_id" => "5VJRATN8BDR8E",
                        "txn_type" => "web_accept",
                       "item_name" => "$55",
                     "mc_currency" => "USD",
                     "item_number" => "",
               "residence_country" => "US",
                        "test_ipn" => "1",
                 "handling_amount" => "0.00",
             "transaction_subject" => "10",
                   "payment_gross" => "50.00",
                        "shipping" => "0.00",
                    "ipn_track_id" => "3bf5d613949cb",
                      "controller" => "paypal",
                          "action" => "callback"
      }.merge(overrides)
    end
  end
end
