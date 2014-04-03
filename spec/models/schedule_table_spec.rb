require "spec_helper"

describe ScheduleTable do
  let!(:today)             { Date.today }

  let!(:start_time_a)      { today + 8.hours }
  let!(:end_time_a)        { today + 12.hours }

  let!(:start_time_b)      { today + 13.hours }
  let!(:end_time_b)        { today + 18.hours }
  
  let!(:start_time_c)      { today + 20.hours }
  let!(:end_time_c)        { today + 22.hours }

  let!(:schedule_day_1_a) { FactoryGirl.create :schedule, date: today + 0.days, start_time: start_time_a, end_time: end_time_a }
  # missing day 2 to simulate missing day
  let!(:schedule_day_3_a) { FactoryGirl.create :schedule, date: today + 2.days, start_time: start_time_a, end_time: end_time_a }
  let!(:schedule_day_3_b) { FactoryGirl.create :schedule, date: today + 2.days, start_time: start_time_b, end_time: end_time_b }
  # missing day 4 to simulate missing day
  let!(:schedule_day_5_c) { FactoryGirl.create :schedule, date: today + 4.days, start_time: start_time_c, end_time: end_time_c }
  # missing day 6 to simulate missing day
  let!(:schedule_day_7_a) { FactoryGirl.create :schedule, date: today + 6.days, start_time: start_time_a, end_time: end_time_a }

  let!(:schedules) { Schedule.all }

  subject { ScheduleTable.new(schedules) }

  describe "#row_by_hour" do
    it "returns 7 columns" do
      expect(subject.row_by_hour(8).size).to be_eql 7
    end

    it "returns each column as schedule when present" do
      subject.row_by_hour(8).compact.each do |column|
        expect(column).to be_kind_of Schedule
      end
    end

    it "returns only schedules by hour" do
      subject.row_by_hour(8).compact.each do |schedule|
        expect(subject.match_hour?(schedule, 8)).to be_true
      end
    end
  end

  describe "#match_hour?" do
    it "returns true if schedule matches hour" do
      expect(subject.match_hour?(schedule_day_1_a, 8)).to be_true
      expect(subject.match_hour?(schedule_day_1_a, 12)).to be_true

      expect(subject.match_hour?(schedule_day_3_b, 13)).to be_true
      expect(subject.match_hour?(schedule_day_3_b, 18)).to be_true

      expect(subject.match_hour?(schedule_day_5_c, 20)).to be_true
      expect(subject.match_hour?(schedule_day_5_c, 22)).to be_true
    end

    it "returns false if schedule does not match hour" do
      expect(subject.match_hour?(schedule_day_3_b, 8)).to  be_false
      expect(subject.match_hour?(schedule_day_5_c, 8)).to  be_false
      expect(subject.match_hour?(schedule_day_3_b, 12)).to be_false
      expect(subject.match_hour?(schedule_day_5_c, 12)).to be_false
    end
  end
end