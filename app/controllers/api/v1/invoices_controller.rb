module Api
  module V1
    class InvoicesController < ApplicationController
      def create
        result = Invoices::CreateService.call(
          user: current_user,
          items_params: invoice_items_params
        )

        if result.success?
          render json: {
            message: "Invoice successfully created",
            invoice: result.invoice.as_json(
              include: {
                invoice_items: {
                  batch: {
                    include: :medicine
                  }
                }
              }
            )
          }, status: :created
        else
          render json: {
            error: result.error
          }, status: :unprocessable_entity
        end
      end

      private

      def current_user
        User.first
      end

      def invoice_items_params
        params.require(:invoice)
              .require(:items)
              .map { |item| item.permit(:medicine_id, :quantity).to_h.symbolize_keys }
      end
    end
  end
end
