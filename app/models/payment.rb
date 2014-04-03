class Payment < ActiveRecord::Base
  include I18n::Alchemy

  belongs_to :invoice
  validates :amount, :transaction_id, presence: true

  after_save :check_invoice

  private

  def check_invoice
    if invoice.payments.sum(:amount) >= invoice.total
      invoice.paid!
    end
  end
end
