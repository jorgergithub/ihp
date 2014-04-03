require "spec_helper"

describe Psychic do
  let(:psychic) { create(:psychic) }

  describe "#featured_reviews" do
    it "returns all reviews marked as festured" do
      featured_review =   create(:featured_review, psychic: psychic)
      featured_review_2 = create(:featured_review, psychic: psychic)
      review = create(:review, psychic: psychic)

      expect(psychic.featured_reviews).to eq [featured_review, featured_review_2]
    end
  end

  describe "#next_week_schedules" do
    subject { psychic.next_week_schedules }

    before { Timecop.freeze(Time.zone.parse("2013-09-28 00:00")) }
    after { Timecop.return }

    before do
      today = Date.today.in_time_zone

      -10.upto(20) do |i|
        date = today + i.days
        start_time = (today + i.days).change(hour: 10)
        end_time = (today + i.days).change(hour: 18)
        create(:schedule, psychic: psychic, date: date, start_time: start_time, end_time: end_time)
      end
    end

    it "returns 7 days" do
      expect(subject.count).to eql(7)
    end

    it "returns Saturday as first entry" do
      expect(subject.first.date.wday).to eql(6)
    end

    it "returns Friday as last entry" do
      expect(subject.last.date.wday).to eql(5)
    end
  end

  describe "#weekly_schedule" do
    subject { psychic.weekly_schedule }

    before do
      Timecop.freeze(current_datetime)
      today = Date.today.in_time_zone

      -10.upto(20) do |i|
        date = today + i.days
        start_time = (today + i.days).change(hour: 10)
        end_time = (today + i.days).change(hour: 18)
        create(:schedule, psychic: psychic, date: date, start_time: start_time, end_time: end_time)
      end
    end

    after { Timecop.return }

    context "when day is a Saturday" do
      let(:current_datetime) { Time.zone.parse("2013-09-28 00:00") }

      it "returns one schedule for each day of the week, up to Friday" do
        expect(subject.size).to eql(7)
      end

      it "returns Saturday as the first schedule" do
        expect(subject.first.date.wday).to eql(6)
      end

      it "returns today as the first schedule" do
        expect(subject.first.date.to_date).to eql(Date.today.in_time_zone.to_date)
      end

      it "returns Friday as the last schedule" do
        expect(subject.last.date.wday).to eql(5)
      end
    end

    context "when day is a Wednesday" do
      let(:current_datetime) { Time.zone.parse("2013-09-25 00:00") }

      it "returns one schedule for each day of the week, up to Friday" do
        expect(subject.size).to eql(3)
      end

      it "returns wednesday as the first schedule" do
        expect(subject.first.date.wday).to eql(3)
      end

      it "returns today as the first schedule" do
        expect(subject.first.date.to_date).to eql(Date.today.in_time_zone.to_date)
      end

      it "returns Friday as the last schedule" do
        expect(subject.last.date.wday).to eql(5)
      end
    end
  end

  describe "#call" do
    let(:psychic) { create(:psychic) }

    before {
      psychic.stub(:create_call)
      psychic.stub(phone: "12345")
    }

    it "creates the call with psychic's first phone number" do
      psychic.call("URL")
      expect(psychic).to have_received(:create_call).with("12345", "URL")
    end
  end
end
