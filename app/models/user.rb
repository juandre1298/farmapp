class User < ApplicationRecord
  has_many :invoices, dependent: :restrict_with_error
  validates :first_name, presence: true
  validates :email, presence: true, uniqueness: true

  validates :role, presence: true, inclusion: {
    in: %w[ employee admin],
    message: "%{value} is not a valid role"
  }
end
