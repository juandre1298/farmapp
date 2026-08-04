class InventoryMailer < ApplicationMailer
  default from: "no-replay@farmapp.com"
  default to: "purchases@farmapp.com"


  def low_stock_warning(medicine, total_stock)
    @medicine = medicine
    mail(
      subject: "Farmapp - Low Stock Warning ##{medicine.id} #{medicine.name}"
    )
  end
end
