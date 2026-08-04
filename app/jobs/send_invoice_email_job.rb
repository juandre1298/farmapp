class SendInvoiceEmailJob < ApplicationJob
  queue_as :mailers

  retry_on StandardError, wait: :exponentially_long, attempts: 3

  discard_on ActiveRecord::RecordNotFound


  def perform(invoice_id)
    InvoiceMailer.creation_notification(invoice_id).deliver_now
  end
end
