class CreateBatches < ActiveRecord::Migration[8.1]
  def change
    create_table :batches do |t|
      t.integer :initial_qty, null: false
      t.integer :remaining_qty, null: false
      t.date :expiration_date, null: false
      t.references :medicine, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true

      t.timestamps

      t.check_constraint "initial_qty >= 0", name: :chk_batches_initial_qty_non_negative
      t.check_constraint "remaining_qty >= 0", name: :chk_batches_remaining_qty_non_negative
    end
  end
end
