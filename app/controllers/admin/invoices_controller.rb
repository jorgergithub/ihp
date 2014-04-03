class Admin::InvoicesController < AuthorizedController
  before_action :find_invoice

  def paid
    @invoices = Invoice.paid.order("id").page(params[:page]).per(params[:per])
  end

  def pending
    @invoices = Invoice.pending.order("id").page(params[:page]).per(params[:per])
  end

  def show
    render "invoices/show"
  end

  protected

  def find_invoice
    @invoice = Invoice.find(params[:id]).localized if params[:id]
  end
end
