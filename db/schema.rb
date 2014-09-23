# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140921210527) do

  create_table "charges", force: true do |t|
    t.integer  "order_id"
    t.integer  "payment_method_id"
    t.integer  "state"
    t.integer  "amount_charged_in_cents"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "charges", ["order_id"], name: "index_charges_on_order_id"
  add_index "charges", ["payment_method_id"], name: "index_charges_on_payment_method_id"
  add_index "charges", ["state"], name: "index_charges_on_state"

  create_table "foods", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "price_in_cents"
    t.integer  "state",                default: 1, null: false
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "preview_file_name"
    t.string   "preview_content_type"
    t.integer  "preview_file_size"
    t.datetime "preview_updated_at"
    t.integer  "goal"
    t.integer  "seller_id"
  end

  add_index "foods", ["seller_id"], name: "index_foods_on_seller_id"

  create_table "foods_places", force: true do |t|
    t.integer "food_id"
    t.integer "place_id"
  end

  add_index "foods_places", ["food_id"], name: "index_foods_places_on_food_id"
  add_index "foods_places", ["place_id"], name: "index_foods_places_on_place_id"

  create_table "locations", force: true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "address_one"
    t.string   "address_two"
    t.string   "city",         default: "Pittsburgh"
    t.string   "state",        default: "PA"
    t.string   "zip",          default: "15213"
    t.string   "country",      default: "United States"
    t.text     "instructions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "latitude"
    t.decimal  "longitude"
  end

  add_index "locations", ["latitude"], name: "index_locations_on_latitude"
  add_index "locations", ["longitude"], name: "index_locations_on_longitude"

  create_table "orders", force: true do |t|
    t.integer  "food_id"
    t.integer  "user_id"
    t.integer  "state",          default: 0, null: false
    t.integer  "quantity",       default: 1, null: false
    t.integer  "price_in_cents",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "delivered_at"
    t.integer  "rating"
    t.integer  "address_id"
  end

  add_index "orders", ["address_id"], name: "index_orders_on_address_id"
  add_index "orders", ["food_id"], name: "index_orders_on_food_id"
  add_index "orders", ["user_id"], name: "index_orders_on_user_id"

  create_table "payment_methods", force: true do |t|
    t.integer  "user_id"
    t.string   "customer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payment_methods", ["customer"], name: "index_payment_methods_on_customer"
  add_index "payment_methods", ["user_id"], name: "index_payment_methods_on_user_id"

  create_table "places", force: true do |t|
    t.string   "name"
    t.boolean  "enabled"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "places", ["location_id"], name: "index_places_on_location_id"

  create_table "sellers", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  create_table "sessions", force: true do |t|
    t.integer  "user_id"
    t.datetime "expiration"
    t.string   "access_token"
    t.string   "token",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["access_token"], name: "index_sessions_on_access_token"
  add_index "sessions", ["token"], name: "index_sessions_on_token"
  add_index "sessions", ["user_id"], name: "index_sessions_on_user_id"

  create_table "users", force: true do |t|
    t.string   "facebook_uid"
    t.string   "email"
    t.string   "phone"
    t.string   "name"
    t.datetime "last_signin"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "location_id"
    t.integer  "seller_id"
  end

  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["facebook_uid"], name: "index_users_on_facebook_uid"
  add_index "users", ["location_id"], name: "index_users_on_location_id"
  add_index "users", ["seller_id"], name: "index_users_on_seller_id"

end
