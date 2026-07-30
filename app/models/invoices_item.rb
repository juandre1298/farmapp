class InvoiceItem < ApplicationRecord
  validates :quantity, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :unit_price_at_sale, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
