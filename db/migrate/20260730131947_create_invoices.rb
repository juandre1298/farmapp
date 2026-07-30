class CreateInvoices < ActiveRecord::Migration[8.1]
  def change
    create_table :invoices do |t|
      t.decimal :total_amount
      t.references :user, null: false, foreign_key: true

      t.timestamps

      t.check_constraint "total_amount >= 0", name: :chk_invoices_total_amount_non_negative
    end
  end
end
