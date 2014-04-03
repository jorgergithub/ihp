require "spec_helper"

describe ClientPhone do
  it { should belong_to(:client) }

  describe "validations" do
    it { should validate_presence_of(:number) }
    it { should validate_uniqueness_of(:number) }
    it { should validate_as_phone_number(:number) }
  end
end
