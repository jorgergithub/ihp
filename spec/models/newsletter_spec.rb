require "spec_helper"

describe Newsletter do
  let!(:newsletter) { FactoryGirl.create(:newsletter, deliver_by: Date.today) }

  describe "#deliver" do
    let!(:client1) { create(:client, receive_newsletters: true) }
    let!(:client2) { create(:client, receive_newsletters: false) }
    let(:mailer)  { double(:mailer).as_null_object }

    before {
      newsletter.stub(:send_email)
      newsletter.deliver
    }

    it "sends only to subscribed clients" do
      newsletter.should have_received(:send_email).with(client1)
      newsletter.should_not have_received(:send_email).with(client2)
    end

    it "sets delivered to true" do
      expect(newsletter.reload).to be_delivered
    end
  end

  describe "#send_email" do
    let(:delay) { double(:delay) }
    let(:client) { double(:client) }

    before {
      NewsletterMailer.stub(delay: delay)
      delay.stub(:send_newsletter)
    }

    it "sends the email to the client" do
      newsletter.send_email(client)
      delay.should have_received(:send_newsletter).with(newsletter, client)
    end
  end

  describe "#delivered?" do
    context "when delivered_at is not null" do
      before { newsletter.delivered_at = Time.now }
      it "is true" do
        expect(newsletter).to be_delivered
      end
    end

    context "when delivered_at is null" do
      it "is false" do
        expect(newsletter).to_not be_delivered
      end
    end
  end

  describe ".deliver_pending" do
    let!(:newsletter1) { create(:newsletter, title: "newsletter1", deliver_by: Time.now - 1.hour) }
    let!(:newsletter2) { create(:newsletter, title: "newsletter2", deliver_by: Time.now) }
    let!(:newsletter3) { create(:newsletter, title: "newsletter3", deliver_by: Time.now, delivered_at: Time.now - 1.hour) }
    let!(:newsletter4) { create(:newsletter, title: "newsletter4", deliver_by: Time.now + 1.hour) }
    let!(:newsletter3_delivered_at) { newsletter3.delivered_at }

    before { Newsletter.deliver_pending }

    it "delivers pending newsletter with deliver_by in the past" do
      expect(newsletter1.reload).to be_delivered
    end

    it "delivers pending newsletter with deliver_by now" do
      expect(newsletter2.reload).to be_delivered
    end

    it "doesn't deliver newsletter that was already delivered" do
      expect(newsletter3.reload.delivered_at.to_i).to eql(newsletter3_delivered_at.to_i)
    end

    it "doesn't deliver pending newsletter with deliver_by in the future" do
      expect(newsletter4.reload).to_not be_delivered
    end
  end
end
