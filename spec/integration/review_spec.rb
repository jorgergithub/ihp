require "spec_helper"

describe Review do
  describe "#mark_as_featured!" do
    let(:psychic) { create(:psychic) }

    it "sets true to featured" do
      review = create(:review, psychic: psychic)
      review.mark_as_featured!

      expect(review).to be_featured
    end
  end
end
