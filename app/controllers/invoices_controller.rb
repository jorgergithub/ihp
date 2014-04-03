class InvoicesController < AuthorizedController
  before_action :find_invoice

  def index
    @pending_invoices = Invoice.pending.where(psychic: @psychic)
      .order("created_at DESC").page(params[:pending_page]).per(params[:per])

    @paid_invoices = Invoice.paid.where(psychic: @psychic)
      .order("created_at DESC").page(params[:paid_page]).per(params[:per])
  end

  def show
  end

  private

  def find_invoice
    @psychic = current_psychic
    @invoice = @psychic.invoices.find(params[:id]) if params[:id]
  end
end
