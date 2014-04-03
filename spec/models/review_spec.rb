require "spec_helper"

describe Review do
  it { should belong_to :call }
  it { should belong_to :client }
  it { should belong_to :psychic }

  it { should delegate(:full_name).to(:client).allowing_nil(true).prefix(true) }
  it { should delegate(:reviews).to(:psychic).allowing_nil(true).prefix(true) }

  describe "validations" do
    it { should validate_presence_of(:client) }
    it { should validate_presence_of(:psychic) }
    it { should validate_presence_of(:rating) }
    it { should validate_presence_of(:text) }
  end
end
