require 'spec_helper'

describe Hour do
  describe "#start?" do
    context "when action is start" do
      let(:hour) { build(:hour, action: "start") }

      it "returns true" do
        expect(hour).to be_start
      end
    end

    context "when action is finish" do
      let(:hour) { build(:hour, action: "finish") }

      it "returns false" do
        expect(hour).to_not be_start
      end
    end
  end
end
