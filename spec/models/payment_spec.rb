require "spec_helper"

describe Payment do
  context "after paying" do
    let(:invoice) { create(:invoice) }

    context "the total amount of the invoice" do
      before {
        invoice.payments.create(amount: invoice.total, transaction_id: "123")
        invoice.reload
      }

      it "sets the invoice paid_at" do
        expect(invoice.paid_at).to_not be_nil
      end
    end

    context "multiple payments surpassing the total amount of the invoice" do
      it "sets the invoice paid_at" do
        invoice.payments.create(amount: invoice.total - 10, transaction_id: "123")
        invoice.reload
        expect(invoice.paid_at).to be_nil

        invoice.payments.create(amount: 10, transaction_id: "123")
        invoice.reload
        expect(invoice.paid_at).to_not be_nil
      end
    end

    context "less than the invoice total" do
      before {
        invoice.payments.create(amount: invoice.total - 10, transaction_id: "123")
        invoice.reload
      }

      it "doesn't set the invoice paid_at" do
        expect(invoice.paid_at).to be_nil
      end
    end
  end
end
