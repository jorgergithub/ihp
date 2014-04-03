require "spec_helper"

describe PsychicFaq do
  it { should belong_to :psychic_faq_category }

  describe "validations" do
    it { should validate_presence_of(:answer) }
    it { should validate_presence_of(:question) }
  end
end
