require "spec_helper"

describe CallsController do
  render_views

  describe "GET index" do
    let!(:user) { create(:user, create_as: "client", first_name: "Felipe") }
    let!(:client) { user.client }

    before {
      client.phones.create(number: "+17863295532")
      get :index, params.merge(format: 'xml')
    }

    context "parsing regular phone format" do
      let(:params) { {"AccountSid"=>"AC335d2ec5149c8618389304932e754045", "ToZip"=>"19365", "FromState"=>"Rostov -on-Don", "Called"=>"+14848571900", "FromCountry"=>"RU", "CallerCountry"=>"RU", "CalledZip"=>"19365", "Direction"=>"inbound", "FromCity"=>"", "CalledCountry"=>"US", "Duration"=>"1", "CallerState"=>"Rostov -on-Don", "CallSid"=>"CA20e79c38e8d29d6b428df36d0d3eeeba", "CalledState"=>"PA", "From"=>"+17863295532", "CallerZip"=>"", "FromZip"=>"", "CallStatus"=>"completed", "ToCity"=>"KEMPTON", "ToState"=>"PA", "To"=>"+14848571900", "CallDuration"=>"7", "ToCountry"=>"US", "CallerCity"=>"", "ApiVersion"=>"2010-04-01", "Caller"=>"+17863295532", "CalledCity"=>"KEMPTON"} }

      it "renders 200" do
        expect(response.status).to eql(200)
      end

      it "recognizes the client" do
        expect(response.body).to include("Felipe")
      end
    end

    context "parsing alternate phone format" do
      let(:params) { {"AccountSid"=>"AC335d2ec5149c8618389304932e754045", "ToZip"=>"19365", "FromState"=>"Rostov -on-Don", "Called"=>"+14848571900", "FromCountry"=>"RU", "CallerCountry"=>"RU", "CalledZip"=>"19365", "Direction"=>"inbound", "FromCity"=>"", "CalledCountry"=>"US", "Duration"=>"1", "CallerState"=>"Rostov -on-Don", "CallSid"=>"CA20e79c38e8d29d6b428df36d0d3eeeba", "CalledState"=>"PA", "From"=>"+7863295532", "CallerZip"=>"", "FromZip"=>"", "CallStatus"=>"completed", "ToCity"=>"KEMPTON", "ToState"=>"PA", "To"=>"+14848571900", "CallDuration"=>"7", "ToCountry"=>"US", "CallerCity"=>"", "ApiVersion"=>"2010-04-01", "Caller"=>"+7863295532", "CalledCity"=>"KEMPTON"} }

      it "recognizes the client" do
        expect(response.body).to include("Felipe")
      end
    end
  end
end
