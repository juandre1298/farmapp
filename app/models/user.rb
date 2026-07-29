class User < ApplicationRecord
  validates :first_name, presence: true
  validates :email, presecet: true, uniqueness: true

  validates :role, presence: true, inclusion: {
    in: %w[ employee admin],
    message: "%{value} is not a valid role"
  }
end
