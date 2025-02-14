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

ActiveRecord::Schema[7.1].define(version: 2025_02_13_173914) do
  create_table "bot_historical_exchange_rates", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "recorded_date", null: false
    t.integer "currency", null: false
    t.decimal "exchange_rate", precision: 7, scale: 4, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency"], name: "index_bot_historical_exchange_rates_on_currency"
    t.index ["recorded_date"], name: "index_bot_historical_exchange_rates_on_recorded_date"
  end

  create_table "exchange_rate_monitors", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "creator_id", null: false
    t.string "bank_name", null: false
    t.integer "currency", null: false
    t.decimal "target_rate", precision: 7, scale: 4, null: false
    t.decimal "rate_at_setting", precision: 7, scale: 4
    t.integer "alert_type", default: 0
    t.text "message_content"
    t.string "note"
    t.datetime "last_scan_datetime"
    t.datetime "expiration_datetime"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bank_name"], name: "index_exchange_rate_monitors_on_bank_name"
    t.index ["creator_id"], name: "index_exchange_rate_monitors_on_creator_id"
    t.index ["currency"], name: "index_exchange_rate_monitors_on_currency"
    t.index ["expiration_datetime"], name: "index_exchange_rate_monitors_on_expiration_datetime"
  end

  create_table "users", primary_key: "id_hash", id: :string, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", null: false
    t.string "nickname"
    t.string "user_name", null: false
    t.string "password_digest"
    t.integer "role", default: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_name"], name: "index_users_on_user_name", unique: true
  end

  add_foreign_key "exchange_rate_monitors", "users", column: "creator_id", primary_key: "id_hash"
end
