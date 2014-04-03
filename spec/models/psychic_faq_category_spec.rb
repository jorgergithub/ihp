require "spec_helper"

describe PsychicFaqCategory do
  it { should have_many(:faqs).dependent(:destroy) }

  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe "#to_slug" do
    it "transforns into a dash separated slug" do
      subject.name = "Some crazy Category 1?"
      expect(subject.to_slug).to eql("some-crazy-category-1")
    end
  end
end
