# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_27_154654) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "addresses", force: :cascade do |t|
    t.string "address_1"
    t.string "address_2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "affiliates", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.string "country"
    t.string "stripe_id"
    t.string "tag"
    t.json "verification_needed"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "stripe_charges_enabled", default: false
    t.boolean "stripe_payouts_enabled", default: false
    t.string "stripe_disabled_reason"
    t.datetime "stripe_validation_due_by"
    t.index ["user_id"], name: "index_affiliates_on_user_id"
  end

  create_table "day_revenues", force: :cascade do |t|
    t.date "day"
    t.integer "ticket_count"
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.integer "discounts_cents", default: 0, null: false
    t.string "discounts_currency", default: "USD", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "discount_codes", force: :cascade do |t|
    t.string "code"
    t.integer "percentage"
    t.text "description"
    t.integer "minimum_amount_cents", default: 0, null: false
    t.string "minimum_amount_currency", default: "USD", null: false
    t.integer "maximum_discount_cents", default: 0, null: false
    t.string "maximum_discount_currency", default: "USD", null: false
    t.integer "max_uses"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "image_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "payment_line_items", force: :cascade do |t|
    t.bigint "payment_id", null: false
    t.string "buyable_type", null: false
    t.bigint "buyable_id", null: false
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "original_line_item_id"
    t.bigint "administrator_id"
    t.integer "refund_status", default: 0
    t.index ["administrator_id"], name: "index_payment_line_items_on_administrator_id"
    t.index ["buyable_type", "buyable_id"], name: "index_payment_line_items_on_buyable_type_and_buyable_id"
    t.index ["original_line_item_id"], name: "index_payment_line_items_on_original_line_item_id"
    t.index ["payment_id"], name: "index_payment_line_items_on_payment_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.integer "status"
    t.string "reference"
    t.string "payment_method"
    t.string "response_id"
    t.json "full_response"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "original_payment_id"
    t.bigint "administrator_id"
    t.bigint "discount_code_id"
    t.integer "discount_cents", default: 0, null: false
    t.string "discount_currency", default: "USD", null: false
    t.json "partials"
    t.integer "billing_address_id"
    t.integer "shipping_address_id"
    t.integer "shipping_method", default: 0
    t.bigint "affiliate_id"
    t.integer "affiliate_payment_cents", default: 0, null: false
    t.string "affiliate_payment_currency", default: "USD", null: false
    t.index ["administrator_id"], name: "index_payments_on_administrator_id"
    t.index ["affiliate_id"], name: "index_payments_on_affiliate_id"
    t.index ["discount_code_id"], name: "index_payments_on_discount_code_id"
    t.index ["original_payment_id"], name: "index_payments_on_original_payment_id"
    t.index ["reference"], name: "index_payments_on_reference"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "performances", force: :cascade do |t|
    t.integer "event_id", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id"], name: "index_performances_on_event_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "remote_id"
    t.string "name"
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.integer "interval"
    t.integer "interval_count"
    t.integer "tickets_allowed"
    t.string "ticket_category"
    t.integer "status"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "shopping_carts", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "address_id"
    t.integer "shipping_method", default: 0
    t.bigint "discount_code_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "affiliate_id"
    t.index ["address_id"], name: "index_shopping_carts_on_address_id"
    t.index ["affiliate_id"], name: "index_shopping_carts_on_affiliate_id"
    t.index ["discount_code_id"], name: "index_shopping_carts_on_discount_code_id"
    t.index ["user_id"], name: "index_shopping_carts_on_user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "plan_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.integer "status"
    t.string "payment_method"
    t.string "remote_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["plan_id"], name: "index_subscriptions_on_plan_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.integer "user_id"
    t.integer "performance_id", null: false
    t.integer "status"
    t.integer "access"
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "payment_reference"
    t.index ["performance_id"], name: "index_tickets_on_performance_id"
    t.index ["user_id"], name: "index_tickets_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "stripe_id"
    t.integer "role", default: 0
    t.string "authy_id"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sing_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "affiliates", "users"
  add_foreign_key "payment_line_items", "payments"
  add_foreign_key "payments", "affiliates"
  add_foreign_key "payments", "users"
  add_foreign_key "performances", "events"
  add_foreign_key "shopping_carts", "addresses"
  add_foreign_key "shopping_carts", "discount_codes"
  add_foreign_key "shopping_carts", "users"
  add_foreign_key "subscriptions", "plans"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "tickets", "performances"
  add_foreign_key "tickets", "users"
end
