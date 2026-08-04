class AddWarningStockLevelToMedicine < ActiveRecord::Migration[8.1]
  def change
    add_column :medicines, :warning_stock_level, :int
  end
end
