require "spec_helper"

describe Category do
  it { should have_many :faqs }

  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe "#to_slug" do
    subject { Category.new(name: "Some crazy Category 1?") }
    it "transforns into a dash separated slug" do
      expect(subject.to_slug).to eql("some-crazy-category-1")
    end
  end
end
