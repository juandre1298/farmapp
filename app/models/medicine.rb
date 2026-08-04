class Medicine < ApplicationRecord
  has_many :batches

  validates :name, presence: true
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :warning_stock_level, numericality: { greater_than_or_equal_to: 0 }
  validates :therapeutic_class, presence: true

  def total_stock
    Batch.where(medicine_id: id).sum(:remaining_qty)
  end

  def total_active_stock
    batches.where("expiration_date >= ?", Date.current).sum(:remaining_qty)
  end

  def self.total_active_stock(medicine_id)
    joins(:batches)
      .where(id: medicine_id)
      .where("batches.expiration_date >= ?", Date.current)
      .sum("batches.remaining_qty")
  end
end
