module Invoices
  class CreateService
    def self.call(user:, items_params:)
      new(user:, items_params:)
    end

    def initialize(user:, items_params:)
      @user = user
      @items_params = items_params
    end

    def call
      ActiveRecord::Base.transaction do
        invoice = user.invoices.build(total_amount: 0)

        total_accumulated = 0

        items_params.each do | item_data |
          batch = batch.lock.find(item_data[:batch_id])
          requested_qty = item_data[:quantity].to_i
        end
      end
    end
  end
end
