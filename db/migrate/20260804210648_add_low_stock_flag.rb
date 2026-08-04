class AddLowStockFlag < ActiveRecord::Migration[8.1]
  def change
    add_column :medicines, :low_stock_flag, :boolean, default: false
  end
end
