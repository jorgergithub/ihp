class Order < ActiveRecord::Base
  include I18n::Alchemy

  attr_accessor :package_id, :card_id, :card_number, :card_exp_month,
                :card_exp_year, :card_cvc, :stripe_token

  belongs_to :client

  has_many :items, class_name: "OrderItem"
  has_many :transactions

  delegate :full_name, to: :client, allow_nil: true, :prefix => true

  before_save :handle_package_item
  before_save :calculate_total

  scope :most_recent, -> { order(created_at: :desc) }

  def package
    return nil unless items.count == 1
    items.first.package
  end

  def to_paypal
    PayPal.new(id, item.package_name, total.to_f)
  end

  def to_desc
    "Order ##{id}"
  end

  def add_package_item(pkg)
    items.build(package: pkg, qty: 1, unit_price: pkg.price,
                total_price: pkg.price, description: pkg.name)
  end

  def pay
    raise OrderError, "order already paid" if paid?
    raise OrderError, "order refunded" if refunded?

    transaction do
      if stripe_token
        client.add_card_from_token(stripe_token)
        self.stripe_token = nil
      end

      client.charge(total, "Order ##{id}", order_id: id)
      self.add_credits

      send_email
    end
  end

  def pay_with_paypal(params)
    transactions.create(
      client: self.client, operation: "charge", transaction_id: params["txn_id"],
      success: true, amount: self.total, card: "PayPal")
    add_credits
  end

  def add_credits
    transaction do
      client.add_credits(item.package_credits, self) if item and item.package
      paid!
    end
  end

  def send_email
    OrderMailer.delay.confirmation_email(self)
  end

  def paid!
    update_attributes status: "paid"
  end

  def paid?
    status == "paid"
  end

  def refunded?
    status == "refunded"
  end

  def paypal?
    payment_method == "paypal"
  end

  def refundable?
    return false unless paid?
    return false if refunded?
    return false if paypal?
    true
  end

  def item
    items.first
  end

  private

  def calculate_total
    self.total = items.inject(0) { |t, i| t += i.total_price }
  end

  def handle_package_item
    return unless self.package_id

    add_package_item(Package.find(package_id))
    self.package_id = nil
  end
end

class OrderError < StandardError; end
