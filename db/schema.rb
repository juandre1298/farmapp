# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_07_30_170354) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "batches", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "expiration_date", null: false
    t.integer "initial_qty", null: false
    t.bigint "location_id", null: false
    t.bigint "medicine_id", null: false
    t.integer "remaining_qty", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_batches_on_location_id"
    t.index ["medicine_id"], name: "index_batches_on_medicine_id"
    t.check_constraint "initial_qty >= 0", name: "chk_batches_initial_qty_non_negative"
    t.check_constraint "remaining_qty >= 0", name: "chk_batches_remaining_qty_non_negative"
  end

  create_table "invoice_items", force: :cascade do |t|
    t.bigint "batch_id", null: false
    t.datetime "created_at", null: false
    t.bigint "invoice_id", null: false
    t.integer "quantity", null: false
    t.decimal "unit_price_at_sale", precision: 10, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id", "invoice_id", "created_at"], name: "index_invoice_items_on_batch_id_and_invoice_id_and_created_at"
    t.index ["batch_id"], name: "index_invoice_items_on_batch_id"
    t.index ["invoice_id", "created_at"], name: "index_invoice_items_on_invoice_id_and_created_at"
    t.index ["invoice_id"], name: "index_invoice_items_on_invoice_id"
    t.check_constraint "quantity > 0", name: "chk_invoice_items_quantity_positive"
    t.check_constraint "unit_price_at_sale >= 0::numeric", name: "chk_invoice_items_price_non_negative"
  end

  create_table "invoices", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "total_amount"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id", "created_at"], name: "index_invoices_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_invoices_on_user_id"
    t.check_constraint "total_amount >= 0::numeric", name: "chk_invoices_total_amount_non_negative"
  end

  create_table "locations", force: :cascade do |t|
    t.string "address"
    t.string "city"
    t.string "country"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_locations_on_name", unique: true
  end

  create_table "medicines", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.string "therapeutic_class", null: false
    t.decimal "unit_price", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.index ["therapeutic_class"], name: "index_medicines_on_therapeutic_class"
    t.check_constraint "unit_price >= 0::numeric", name: "chk_medicines_unit_price_non_negative"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "last_name"
    t.string "role", default: "employee", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "batches", "locations"
  add_foreign_key "batches", "medicines"
  add_foreign_key "invoice_items", "batches"
  add_foreign_key "invoice_items", "invoices"
  add_foreign_key "invoices", "users"
end
