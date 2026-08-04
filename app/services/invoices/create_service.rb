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
          requested_qty = item_data[:quantity].to_i

          if requested_qty <= 0
            custom_error = "Quantity for medicine must be greater than zero."
            raise ActiveRecord::Rollback
          end

          medicine = Medicine.find_by(id: item_data[:medicine_id])
          unless medicine
            custom_error = "Medicine ##{item_data[:medicine_id]} not found."
            raise ActiveRecord::Rollback
          end

          # Base Scope para FEFO sin lock (para poder usar .sum)
          fefo_scope = Batch.where(medicine_id: medicine.id)
                            .where("remaining_qty > 0 AND expiration_date >= ?", Date.current)

          # 1. Validar el total disponible mediante SUM sin el .lock
          total_available = fefo_scope.sum(:remaining_qty)

          if requested_qty > total_available
            custom_error = "Insufficient stock for #{medicine.name}. Requested: #{requested_qty}, Available: #{total_available}."
            raise ActiveRecord::Rollback
          end

          unit_price = medicine.unit_price

          # 2. Cargar y BLOQUEAR los registros de filas individuales (FOR UPDATE)
          locked_batches = fefo_scope.order(expiration_date: :asc).lock

          # Iteración para consumir los lotes de forma secuencial
          locked_batches.each do |batch|
            break if requested_qty <= 0

            invoice_items_qty = [ batch.remaining_qty, requested_qty ].min

            batch.remaining_qty -= invoice_items_qty
            batch.save!

            requested_qty -= invoice_items_qty

            invoice.invoice_items.build(
              batch: batch,
              quantity: invoice_items_qty,
              unit_price_at_sale: unit_price
            )

            total_accumulated += (invoice_items_qty * unit_price)
          end
          if requested_qty > 0
            custom_error = "Concurrent update detected: Stock for #{medicine.name} was reduced during processing. Please try again."
            raise ActiveRecord::Rollback
          end
        end

        invoice.total_amount = total_accumulated
        invoice.save!

        created_invoice = invoice
      end

      if created_invoice&.persisted?
        SendInvoiceEmailJob.perform_later(created_invoice)
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
