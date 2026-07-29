class CreateMedicines < ActiveRecord::Migration[8.1]
  def change
    create_table :medicines do |t|
      t.string :name, null: false
      t.text :description
      t.decimal :unit_price, null: false, default: 0, precision: 10, scale: 2

      t.timestamps

      t.check_constraint "unit_price >= 0", name: "chk_medicines_unit_price_non_negative"
    end
  end
end
