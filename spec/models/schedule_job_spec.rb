require "spec_helper"

describe ScheduleJob do
  describe "validations" do
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:week_day) }
    it { should validate_presence_of(:at) }
    it { should validate_presence_of(:model) }
    it { should validate_presence_of(:action) }
  end
end
