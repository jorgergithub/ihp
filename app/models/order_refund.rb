class OrderRefund
  def initialize(order)
    @order = order

    validate_order
  end

  def process!
    refund!
  end

  private

  attr_reader :order

  delegate :client, :paid?, :refunded?, to: :order
  delegate :item, to: :order, allow_nil: true, prefix: true

  def validate_order
    raise OrderError, "Order not paid yet" unless paid?
    raise OrderError, "Order already refunded" if refunded?
  end

  def refund!
    charge_refund = charge.refund
    create_refund_transaction!(charge_refund.id)
    mark_order_as_refunded
    remove_credits
    charge_refund
  rescue Stripe::StripeError => error
    Rails.logger.error "Order: #{order.id} - Stripe error: #{error.mesage}"
    raise OrderError, error.message
  end

  def create_refund_transaction!(charge_refund_id)
    Transaction.create!(client: client,
                        order: order,
                        transaction_id: charge_refund_id,
                        card: transaction.card,
                        amount: -transaction.amount,
                        success: true)
  end

  def mark_order_as_refunded
    order.update_attributes(status: "refunded")
  end

  def remove_credits
    if order_item and order_item.package
      client.remove_credits(order_item.package_credits, order)
    end
  end

  def charge
    @charge ||= Stripe::Charge.retrieve(transaction.transaction_id)
  end

  def transaction
    @transaction ||= Transaction.where(order: order, operation: "charge").first
  end
end
