require "spec_helper"

describe ReviewsController do
  let(:review) { create(:review) }
  let(:user) { review.psychic.user }

  before {
    user.confirm!
    sign_in user
  }

  describe "GET mark_as_featured" do

    context "as js" do
      before { get :mark_as_featured, id: review.id, format: :js }
      
      it "renders success" do
        expect(response).to render_template :mark_as_featured
      end
    end

    context "as html" do
      before { get :mark_as_featured, id: review.id }
      it "redirects back to the psychic page" do
        expect(response).to redirect_to(edit_psychic_path)
      end

      it "sets a flash message" do
        expect(flash[:notice]).to eql("Review successfully marked as featured.")
      end
    end

    it "makes the review featured" do
      get :mark_as_featured, id: review.id
      expect(review.reload).to be_featured
    end
  end

  describe "GET unmark_as_featured" do
    before { review.update_attributes featured: true }

    context "as js" do
      before { get :unmark_as_featured, id: review.id, format: :js }

      it "renders success" do
        expect(response).to render_template :unmark_as_featured
      end
    end

    context "as html" do
      before { get :unmark_as_featured, id: review.id }

      it "redirects back to the psychic page" do
        expect(response).to redirect_to(edit_psychic_path)
      end

      it "sets a flash message" do
        expect(flash[:notice]).to eql("Review successfully unmarked as featured.")
      end
    end

    it "makes the review featured" do
      get :unmark_as_featured, id: review.id
      expect(review.reload).to_not be_featured
    end
  end
end
