class InvoiceMailer < ApplicationMailer
  default from: "no-replay@farmapp.com"

  def creation_notification(invoice_id)
    @invoice = Invoice.includes(:user, invoice_items: { batch: :medicine }).find(invoice_id)
    @user = @invoice.user

    mail(
      to: @user.email,
      subject: "Invoice ##{@invoice.id} - Farmapp"
    )
  end
end
