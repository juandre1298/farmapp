class CreateInvoiceItems < ActiveRecord::Migration[8.1]
  def change
    create_table :invoice_items do |t|
      t.integer :quantity, null: false
      t.decimal :unit_price_at_sale, precision: 10, scale: 2, null: false

      t.references :invoice, null: false, foreign_key: true
      t.references :batch, null: false, foreign_key: true

      t.timestamps

      t.check_constraint "quantity > 0", name: :chk_invoice_items_quantity_positive
      t.check_constraint "unit_price_at_sale >= 0", name: :chk_invoice_items_price_non_negative
    end
  end
end
