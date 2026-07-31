# app/services/invoices/create_service.rb
module Invoices
  class CreateService
    Result = Struct.new(:success?, :invoice, :error, keyword_init: true)

    def self.call(user:, items_params:)
      new(user:, items_params:).call
    end

    def initialize(user:, items_params:)
      @user = user
      @items_params = items_params
    end

    def call
      created_invoice = nil
      custom_error = nil

      ActiveRecord::Base.transaction do
        invoice = user.invoices.build(total_amount: 0)
        total_accumulated = 0

        items_params.each do |item_data|
          batch = Batch.lock.find(item_data[:batch_id])
          requested_qty = item_data[:quantity].to_i

          if requested_qty <= 0
            custom_error = "Quantity for batch ##{batch.id} must be greater than zero."
            raise ActiveRecord::Rollback
          end

          if batch.remaining_qty < requested_qty
            custom_error = "Insufficient stock for #{batch.medicine.name} (Batch ##{batch.id}). Available: #{batch.remaining_qty}."
            raise ActiveRecord::Rollback
          end

          batch.remaining_qty -= requested_qty
          batch.save!

          unit_price = batch.medicine.unit_price

          invoice.invoice_items.build(
            batch: batch,
            quantity: requested_qty,
            unit_price_at_sale: unit_price
          )

          total_accumulated += (requested_qty * unit_price)
        end

        invoice.total_amount = total_accumulated
        invoice.save!

        created_invoice = invoice
      end

      if created_invoice&.persisted?
        Result.new(success?: true, invoice: created_invoice, error: nil)
      else
        Result.new(success?: false, invoice: nil, error: custom_error || "Couldn't process the sale. Check Parameters.")
      end
    rescue ActiveRecord::RecordInvalid => e
      Result.new(success?: false, invoice: nil, error: e.message)
    rescue StandardError => e
      Result.new(success?: false, invoice: nil, error: e.message)
    end

    private

    attr_reader :user, :items_params
  end
end
