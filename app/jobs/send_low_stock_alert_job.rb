# app/jobs/send_low_stock_alert_job.rb
class SendLowStockAlertJob < ApplicationJob
  queue_as :low_priority

  retry_on StandardError, wait: :exponentially_longer, attempts: 3

  def perform(medicine_id)
    medicine = Medicine.find_by(id: medicine_id)
    return unless medicine

    total_stock = medicine.total_active_stock

    # Confirmamos que sigue en stock crítico
    if medicine.warning_stock_level && total_stock <= medicine.warning_stock_level
      InventoryMailer.low_stock_warning(medicine, total_stock).deliver_now
    end
  end
end
