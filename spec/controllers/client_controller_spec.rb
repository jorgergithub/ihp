require "spec_helper"

describe ClientsController do
  let(:user) { create(:user, create_as: "client") }
  let(:client) { user.client }

  before {
    client.update_attributes(balance: 50)
    user.confirm!
    sign_in user
  }

  describe "GET show" do
    context "when user has credits" do
      before {
        get :show
      }

      it "shows the dashboard" do
        expect(response).to be_ok
      end
    end

    context "when user is out of credits" do
      before {
        client.update_attributes(balance: 0)
        get :show
      }

      it "redirects to new order" do
        expect(response).to redirect_to(:new_order)
      end
    end

    context "when a psychic the user had a call with was deleted" do
      render_views
      let!(:psychic) { create(:psychic) }
      let!(:call) { create(:processed_call, client: client, psychic: psychic) }

      before {
        psychic.destroy
        get :show
      }

      it "renders show template" do
        expect(response).to render_template("show")
      end
    end
  end

  describe "POST destroy_card" do
    before do
      client.cards.create!
      client.cards.create!  
      delete :destroy_card, format: :js
    end

    it "deletes clients card" do
      expect( client.reload.cards.count ).to be_eql 0
    end

    it "renders success" do
      expect(response).to be_success
    end
  end
end
