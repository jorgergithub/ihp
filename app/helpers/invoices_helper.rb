module InvoicesHelper
  def status(invoice)
    invoice.paid? ? 'paid' : 'pending'
  end
end
