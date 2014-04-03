class Admin::PaymentsController < AuthorizedController
  def new
    @invoice = Invoice.find(params[:invoice_id])
    @payment = @invoice.payments.new(amount: @invoice.total - @invoice.payments.sum(:amount))
  end

  def show
    @invoice = Invoice.find(params[:invoice_id])
    @payment = @invoice.payments.new(amount: @invoice.total)

    render :new
  end

  def create
    @invoice = Invoice.find(params[:invoice_id])
    @payment = @invoice.payments.build(invoice_params)

    if @payment.save
      redirect_to pending_admin_invoices_path, notice: "Payment was successfully saved."
    else
      render action: "show"
    end
  end

  protected

  def invoice_params
    params.require(:payment).permit(:amount, :transaction_id)
  end
end
