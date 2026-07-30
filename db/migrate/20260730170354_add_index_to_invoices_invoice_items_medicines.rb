class AddIndexToInvoicesInvoiceItemsMedicines < ActiveRecord::Migration[8.1]
  def change
    add_index :invoice_items, [ :invoice_id, :created_at ]
    add_index :invoice_items, [ :batch_id, :invoice_id, :created_at ]
    add_index :invoices, [ :user_id, :created_at ]
    add_index :medicines, :therapeutic_class
  end
end
