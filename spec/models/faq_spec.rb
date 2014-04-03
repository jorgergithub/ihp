require "spec_helper"

describe Faq do
  it { should belong_to :category }

  describe "validations" do
    it { should validate_presence_of(:answer) }
    it { should validate_presence_of(:question) }
  end
end
