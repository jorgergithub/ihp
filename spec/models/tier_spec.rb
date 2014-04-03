require 'spec_helper'

describe Tier do
  describe "#payout_for" do
    let(:call) { double(:call) }
    subject { Tier.new(percent: 14) }

    before {
      call.stub(duration: 10, rate: 4.50)
    }

    it "returns the duration times the psychic rate and applies the percentual" do
      expect(subject.payout_for(call)).to eql(6.3) # 10 * 4.50 * 0.14 (14%)
    end
  end
end
