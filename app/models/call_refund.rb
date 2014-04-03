class CallRefund
  def initialize(call)
    @call = call
  end

  def process!
    refund!
  end

  private

  def refund!
    return if @call.refunded?

    ActiveRecord::Base.transaction do
      give_amount_back
      mark_as_refunded
    end
  end

  def give_amount_back
    return unless @call

    client = @call.client

    client.credits.create(
      credits: @call.cost,
      description: "Refunded call \##{@call.id} with #{@call.psychic_alias_name}",
      target: @call
    )

    client.balance ||= 0
    client.balance += @call.cost

    client.save
  end

  def mark_as_refunded
    @call.update_attributes(status: "refunded")
  end
end
