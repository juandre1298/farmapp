class Batch < ApplicationRecord
  belongs_to :medicine
  belongs_to :location

  before_validation :set_default_remaining_qty, on: :create

  validates :initial_qty, presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validates :remaining_qty, presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validates :expiration_date, presence: true

  validate :remaining_qty_cannot_exceed_initial_qty

  def expired?
    expiration_date < Date.current
  end

  private

  def set_default_remaining_qty
    self.remaining_qty ||= initial_qty
  end

  def remaining_qty_cannot_exceed_initial_qty
    return if remaining_qty.blank? || initial_qty.blank?

    if remaining_qty > initial_qty
      errors.add(:remaining_qty, "no puede ser mayor que la cantidad inicial (#{initial_qty})")
    end
  end
end
