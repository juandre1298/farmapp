class UpdateMedicines < ActiveRecord::Migration[8.1]
  def change
    add_column :medicines, :therapeutic_class, :string, null: false
  end
end
