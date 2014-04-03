require "spec_helper"

describe Admin::ReviewsController do
  let(:user) { create(:user, role: "admin") }
  let(:review) { create(:review) }

  before {
    user.confirm!
    sign_in user
  }

  describe "GET mark_as_featured" do
    before { get :mark_as_featured, id: review.id }

    it "redirects back to the psychic page" do
      expect(response).to redirect_to(edit_admin_psychic_path(review.psychic))
    end

    it "sets a flash message" do
      expect(flash[:notice]).to eql("Review successfully marked as featured.")
    end

    it "makes the review featured" do
      expect(review.reload).to be_featured
    end
  end

  describe "GET unmark_as_featured" do
    before {
      review.update_attributes featured: true
      get :unmark_as_featured, id: review.id
    }

    it "redirects back to the psychic page" do
      expect(response).to redirect_to(edit_admin_psychic_path(review.psychic))
    end

    it "sets a flash message" do
      expect(flash[:notice]).to eql("Review successfully unmarked as featured.")
    end

    it "makes the review featured" do
      expect(review.reload).to_not be_featured
    end
  end
end
