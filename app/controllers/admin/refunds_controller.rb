class Admin::RefundsController < AuthorizedController
  before_action :find_order

  def create
    if OrderRefund.new(@order).process!
      redirect_to admin_order_path(@order), notice: "Order was successfully refunded."
    else
      redirect_to admin_order_path(@order), error: "Order was not refunded."
    end
  rescue OrderError => error
    flash[:error] = error.message
    redirect_to admin_order_path(@order)
  end

  private

  def find_order
    @order = Order.find(params[:order_id]) if params[:order_id]
  end
end
