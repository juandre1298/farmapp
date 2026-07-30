class Invoice < ApplicationRecord
  belongs_to :user

  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0, precision: 10, scale: 2 }
end
