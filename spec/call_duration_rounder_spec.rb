require 'spec_helper'
require 'call_duration_rounder'

describe CallDurationRounder do
  it "rounds seconds to minutes" do
    CallDurationRounder.new(59).round.should == 1
    CallDurationRounder.new(60).round.should == 1
    CallDurationRounder.new(61).round.should == 2
    CallDurationRounder.new(119).round.should == 2
    CallDurationRounder.new(120).round.should == 2
    CallDurationRounder.new(121).round.should == 3
  end
end
