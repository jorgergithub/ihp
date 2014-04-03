require "spec_helper"

describe Calls::PsychicCallbacksController do
  let(:user1) { create(:user, create_as: "client", first_name: "Felipe", last_name: "Coury") }
  let(:client) { user1.client }

  let(:user2) { create(:user, create_as: "psychic", first_name: "Mike", last_name: "Vid") }
  let(:psychic) { user2.psychic }

  let(:callback) { create(:callback, client: client, psychic: psychic) }

  before {
    Callback.any_instance.stub(:modify_call)
  }

  describe "POST create initial action" do
    before {
      post :create, callback_id: callback.id, CallSid: "123"
    }

    it "renders 200" do
      expect(response.status).to eql(200)
    end

    it "greets the psychic" do
      expect(response.body).to match(/Hello #{callback.psychic.first_name}/)
    end
  end

  describe "POST menu option 1 - continue with the callback" do
    before {
      post :create, callback_id: callback.id, CallSid: "123"
      post :create, callback_id: callback.id, CallSid: "123", Digits: "1"
    }

    it "renders 200" do
      expect(response.status).to eql(200)
    end

    it "tells the psychic we're connecting with the client" do
      expect(response.body).to match(/Please wait while we connect Felipe/)
    end

    it "puts the user on the callback conference" do
      expect(response.body).to include("<Conference>callback-#{callback.id}</Conference>")
    end

    it "sends the URL to handle when the call is finished" do
      expect(response.body).to include("/calls/psychic_callbacks?callback_id=#{callback.id}")
    end
  end

  describe "POST menu option 2 - cancel the callback" do
    before {
      post :create, callback_id: callback.id, CallSid: "123"
      post :create, callback_id: callback.id, CallSid: "123", Digits: "2"
    }

    it "renders 200" do
      expect(response.status).to eql(200)
    end

    it "tells the psychic the callback is being cancelled" do
      expect(response.body).to match(/Okay Mike, we are now cancelling your callback./)
    end

    it "cancels the callback" do
      expect(callback.reload.status).to eql("cancelled_by_psychic")
    end
  end
end
