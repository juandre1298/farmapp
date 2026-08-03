# app/controllers/api/v1/invoices_controller.rb
module Api
  module V1
    class InvoicesController < ApplicationController
      def index
        query_result = InvoicesQuery.call(filter_params)

        render json: {
          message: "Invoices successfully fetched",
          meta: query_result[:meta],
          invoices: query_result[:records].as_json(
            include: {
              invoice_items: {
                include: {
                  batch: {
                    include: :medicine
                  }
                }
              }
            }
          )
        }, status: :ok
      end

      # POST /api/v1/invoices
      def create
        user = User.find_by(role: "admin") || User.first

        result = Invoices::CreateService.call(
          user: user,
          items_params: invoice_items_params
        )

        if result.success?
          render json: {
            message: "Invoice successfully created",
            invoice: result.invoice.as_json(
              include: {
                invoice_items: {
                  include: {
                    batch: {
                      include: :medicine
                    }
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

      def filter_params
        params.permit(:user_id, :start_date, :end_date, :page, :per_page, :order_dir)
      end

      def invoice_items_params
        params.require(:invoice)
              .require(:items)
              .map { |item| item.permit(:medicine_id, :quantity).to_h.symbolize_keys }
      end
    end
  end
end
