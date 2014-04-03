require "spec_helper"

describe Invoice do
  it { should belong_to :psychic }
  it { should belong_to :tier }

  it { should have_many(:calls).dependent(:nullify) }
  it { should have_many(:payments) }

  describe ".generate" do
    context "when today is Sunday" do
      before { Timecop.freeze(Time.zone.parse("2013-09-22 23:59")) }
      after { Timecop.return }

      it "creates for last Sunday until Monday at midnight" do
        start_date = Date.parse("2013-09-15").in_time_zone
        end_date = Date.parse("2013-09-23").in_time_zone

        Invoice.should_receive(:create_for).with(start_date, end_date)
        Invoice.generate
      end
    end

    context "when today is Monday" do
      before { Timecop.freeze(Time.zone.parse("2013-09-23 00:02")) }
      after { Timecop.return }

      it "creates for 2 Sundays ago until last Monday at midnight" do
        start_date = Date.parse("2013-09-15").in_time_zone
        end_date = Date.parse("2013-09-23").in_time_zone

        Invoice.should_receive(:create_for).with(start_date, end_date)
        Invoice.generate
      end
    end

    context "when today is Wednesday" do
      before { Timecop.freeze(Time.zone.parse("2013-09-25 00:02")) }
      after { Timecop.return }

      it "creates for the previous Sunday until last Monday at midnight" do
        start_date = Date.parse("2013-09-15").in_time_zone
        end_date = Date.parse("2013-09-23").in_time_zone

        Invoice.should_receive(:create_for).with(start_date, end_date)
        Invoice.generate
      end
    end
  end

  describe ".create_for" do
    let(:psychic) { create(:psychic, price: 4.50) }

    before do
      Tier.create(from: 0, to: 999, name: "Bronze", percent: 14)
      Tier.create(from: 1000, to: 1199, name: "Silver", percent: 19)
      Tier.create(from: 1200, to: 1599, name: "Gold", percent: 19.5)
      Tier.create(from: 1600, to: 1999, name: "Platinum", percent: 20)
      Tier.create(from: 2000, to: 999999, name: "Diamond", percent: 21)
    end

    context "when some calls are already invoiced" do
      let!(:other_invoice) { create(:invoice) }
      let!(:call1) { create(:call, psychic: psychic, original_duration: "30000", started_at: "2013-01-01 10:00", rate: psychic.price, cost: 4.50 * 500) } # 2250
      let!(:call2) { create(:call, psychic: psychic, original_duration: "27600", started_at: "2013-01-02 11:00", rate: psychic.price, cost: 4.50 * 460, invoice: other_invoice) } # 2070

      let(:invoice) { Invoice.last }

      before {
        Invoice.create_for("2013-01-01 00:00", "2013-01-08 00:00")
      }

      it "includes the first call" do
        expect(invoice.calls).to include(call1)
      end

      it "marks the call as invoiced" do
        expect(call1.reload).to be_invoiced
      end

      it "doesn't include that call" do
        expect(invoice.calls).not_to include(call2)
      end
    end

    context "when psychic has between 1000 and 1199 minutes" do
      let!(:call1) { create(:call, psychic: psychic, original_duration: "30000", started_at: "2013-01-01 10:00", rate: psychic.price, cost: 4.50 * 500) } # 2250
      let!(:call2) { create(:call, psychic: psychic, original_duration: "27600", started_at: "2013-01-02 11:00", rate: psychic.price, cost: 4.50 * 460) } # 2070
      let!(:call3) { create(:call, psychic: psychic, original_duration: "10800", started_at: "2013-01-02 11:00", rate: psychic.price, cost: 4.50 * 180) } #  810 == 5130

      let(:invoice) { Invoice.first }

      before {
        Invoice.create_for("2013-01-01 00:00", "2013-01-08 00:00")
      }

      it "creates one invoice" do
        expect(Invoice.count).to eql(1)
      end

      it "sets the number of minutes" do
        expect(invoice.total_minutes).to eql(1140)
      end

      it "sets the correct tier" do
        expect(invoice.tier).to eql(Tier.where(name: "Silver").take)
      end

      it "sets the minutes payout" do
        expect(invoice.minutes_payout.to_f).to eql(974.7)
      end

      it "sets the total to the minutes total" do
        expect(invoice.total.to_f).to eql(974.7)
      end

      it "sets the average minutes per call" do
        expect(invoice.avg_minutes.to_f).to eql(380.0)
      end

      it "sets the start date" do
        expect(invoice.start_date.to_s).to eql("2013-01-01")
      end

      it "sets the end date" do
        expect(invoice.end_date.to_s).to eql("2013-01-08")
      end

      context "when there are calls placed between 12AM and 8AM" do
        let!(:call1) { create(:call, psychic: psychic, original_duration: "30000", started_at: "2013-01-01 10:00", rate: psychic.price, cost: 4.50 * 500) } # 2250
        let!(:call2) { create(:call, psychic: psychic, original_duration: "27600", started_at: "2013-01-02 00:30", rate: psychic.price, cost: 4.50 * 460) } # 2070
        let!(:call3) { create(:call, psychic: psychic, original_duration: "10800", started_at: "2013-01-04 00:30", rate: psychic.price, cost: 4.50 * 180) } #  810 == 5130

        it "has the same calls" do
          expect(invoice.calls.count).to eql(3)
        end

        it "has the same minutes payout" do
          expect(invoice.minutes_payout.to_f).to eql(974.7)
        end

        it "has some bonus payout" do
          expect(invoice.bonus_payout.to_f).to eql(44.8)
        end

        it "has some bonus minutes" do
          expect(invoice.bonus_minutes).to eql(640)
        end

        it "sets the total with a sum of minutes and bonuses" do
          expect(invoice.total.to_f).to eql(1019.5)
        end
      end
    end

    context "when psychic has up to 1000 minutes" do
      let!(:call1) { create(:call, psychic: psychic, original_duration: "30000", started_at: "2013-01-01 10:00", rate: psychic.price, cost: 4.50 * 500) }
      let!(:call2) { create(:call, psychic: psychic, original_duration: "29940", started_at: "2013-01-02 11:00", rate: psychic.price, cost: 4.50 * 499) }
      let(:invoice) { Invoice.first }

      before {
        Invoice.create_for("2013-01-01 00:00", "2013-01-08 00:00")
      }

      it "creates one invoice" do
        expect(Invoice.count).to eql(1)
      end

      it "sets the number of minutes" do
        expect(invoice.total_minutes).to eql(999)
      end

      it "sets the correct tier" do
        expect(invoice.tier).to eql(Tier.where(name: "Bronze").take)
      end

      it "sets the minutes payout" do
        expect(invoice.minutes_payout.to_f).to eql(629.37)
      end

      it "sets the total to the minutes total" do
        expect(invoice.total.to_f).to eql(629.37)
      end

      it "sets the average minutes per call" do
        expect(invoice.avg_minutes.to_f).to eql(499.5)
      end

      context "when there are calls placed between 12AM and 8AM" do
        let!(:call1) { create(:call, psychic: psychic, original_duration: "30000", started_at: "2013-01-01 10:00", rate: psychic.price, cost: 4.50 * 500) }
        let!(:call2) { create(:call, psychic: psychic, original_duration: "29940", started_at: "2013-01-02 05:00", rate: psychic.price, cost: 4.50 * 499) }

        it "has the same minutes payout" do
          expect(invoice.minutes_payout.to_f).to eql(629.37)
        end

        it "has some bonus payout" do
          expect(invoice.bonus_payout.to_f).to eql(34.93)
        end

        it "has some bonus minutes" do
          expect(invoice.bonus_minutes).to eql(499)
        end

        it "sets the total with a sum of minutes and bonuses" do
          expect(invoice.total.to_f).to eql(664.3)
        end
      end
    end

    context "when call has a discounted price" do
      let!(:call1) { create(:call, psychic: psychic, original_duration: "30000", started_at: "2013-01-01 10:00", rate: psychic.price, cost: 1 * 500) }
      let!(:call2) { create(:call, psychic: psychic, original_duration: "29940", started_at: "2013-01-02 11:00", rate: psychic.price, cost: 1 * 499) }
      let(:invoice) { Invoice.first }

      before {
        Invoice.create_for("2013-01-01 00:00", "2013-01-08 00:00")
      }

      it "creates one invoice" do
        expect(Invoice.count).to eql(1)
      end

      it "sets the number of minutes" do
        expect(invoice.total_minutes).to eql(999)
      end

      it "sets the correct tier" do
        expect(invoice.tier).to eql(Tier.where(name: "Bronze").take)
      end

      it "sets the minutes payout" do
        expect(invoice.minutes_payout.to_f).to eql(629.37)
      end

      it "sets the total to the minutes total" do
        expect(invoice.total.to_f).to eql(629.37)
      end

      it "sets the average minutes per call" do
        expect(invoice.avg_minutes.to_f).to eql(499.5)
      end
    end
  end

  describe "#number" do
    let(:invoice) { build(:invoice) }

    context "when id is present" do
      before { invoice.id = 270 }
      it "returns a zero padded invoice number" do
        expect(invoice.number).to eql("00000270")
      end
    end

    context "when id is nil" do
      it "returns nil" do
        expect(invoice.number).to be_nil
      end
    end
  end

  describe "#paid!" do
    let(:invoice) { create(:invoice) }
    let(:now) { Time.parse("2013-01-01 00:00") }

    before {
      Time.stub(now: now)
      invoice.paid!
    }

    it "sets the invoice paid_at to current time" do
      expect(invoice.paid_at).to eql(now)
    end
  end

  describe "#paid?" do
    let(:invoice) { build(:invoice) }

    context "when paid_at is nil" do
      it "is false" do
        expect(invoice).not_to be_paid
      end
    end

    context "when paid_at has a value" do
      before { invoice.paid_at = Time.now }
      it "is true" do
        expect(invoice).to be_paid
      end
    end
  end

  describe "#period" do
    let(:invoice) { create(:invoice, start_date: "2013-01-01", end_date: "2013-02-01") }

    it "returns the period in dates" do
      expect(invoice.period).to eql("Jan 01 to Feb 01")
    end
  end
end
