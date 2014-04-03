class Newsletter < ActiveRecord::Base
  validates_presence_of :title, :body, :deliver_by

  scope :pending, -> { where('delivered_at IS NULL') }
  scope :available, -> { where('deliver_by <= ?', Time.now) }

  def self.deliver_pending
    Newsletter.pending.available.find_each do |newsletter|
      newsletter.deliver
    end
  end

  def deliver
    Client.subscribed.each do |client|
      send_email(client)
    end
    update_attributes delivered_at: Time.now
  end

  def send_email(client)
    NewsletterMailer.delay.send_newsletter(self, client)
  end

  def delivered?
    delivered_at.present?
  end

  def deliver_by_str
    return "" unless deliver_by
    deliver_by.strftime("%m/%d/%Y %I:%M %p")
  end

  def deliver_by_str=(s)
    self.deliver_by = DateTime.strptime(s, "%m/%d/%Y %I:%M %p")
  end
end
