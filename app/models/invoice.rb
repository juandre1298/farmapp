# app/models/invoice.rb
class Invoice < ApplicationRecord
  belongs_to :user

  has_many :invoice_items, dependent: :destroy
  has_many :batches, through: :invoice_items

  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
