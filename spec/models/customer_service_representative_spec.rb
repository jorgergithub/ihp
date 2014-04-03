require "spec_helper"

describe CustomerServiceRepresentative do
  it { should belong_to :user }

  it { should delegate(:email).to(:user).allowing_nil(true) }
  it { should delegate(:first_name).to(:user).allowing_nil(true) }
  it { should delegate(:full_name).to(:user).allowing_nil(true) }
  it { should delegate(:last_name).to(:user).allowing_nil(true) }
  it { should delegate(:username).to(:user).allowing_nil(true) }

  describe "validations" do
    it { should validate_presence_of(:phone) }
    it { should validate_as_phone_number(:phone) }
  end

  describe "#status" do
    context "when available is true" do
      it "returns available" do
        subject.available = true

        expect(subject.status).to eq "Available"
      end
    end

    context "when available is false" do
      it "returns unavailable" do
        subject.available = false

        expect(subject.status).to eq "Unavailable"
      end
    end
  end
end
