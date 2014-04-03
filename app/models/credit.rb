class Credit < ActiveRecord::Base
  belongs_to :client
  belongs_to :target, polymorphic: true

  scope :by_date, -> { order("created_at") }
  scope :from_orders, -> { where("target_type = ?", "Order") }

  def parsed_time_only
    created_at.strftime("%I:%M %p")
  end

  def parsed_date_only
    created_at.strftime("%b %d, %Y")
  end

  def payment
    if target.respond_to?(:transactions)
      target.transactions.first.card
    else
      "N/A"
    end
  end

  def amount
    if target.respond_to?(:transactions)
      target.transactions.first.amount
    else
      "N/A"
    end
  end
end
