class Admin::OrdersController < AuthorizedController
  def index
    @orders = Order.most_recent.page(params[:page]).per(params[:per])
  end

  def show
    @order = Order.find(params[:id])
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)

    if @order.save
      @order.pay
      redirect_to admin_orders_path, notice: "Order was successfully processed"
    else
      render action: :new
    end
  rescue Stripe::CardError
    logger.info "CardError: #{$!.message}"
    flash[:error] = $!.message
    render action: :new
  end

  private

  def order_params
    params.require(:order).permit(:card_id, :card_cvc, :stripe_token, :client_id, :package_id)
  end
end
