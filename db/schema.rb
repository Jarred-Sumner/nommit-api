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

ActiveRecord::Schema.define(version: 20140831004342) do

  create_table "foods", force: true do |t|
    t.string   "title"
    t.string   "place"
    t.text     "description"
    t.integer  "price_in_cents"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: true do |t|
    t.integer  "food_id"
    t.integer  "user_id"
    t.integer  "quantity",       default: 1, null: false
    t.integer  "price_in_cents",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["food_id"], name: "index_orders_on_food_id"
  add_index "orders", ["user_id"], name: "index_orders_on_user_id"

  create_table "users", force: true do |t|
    t.string   "facebook_uid"
    t.string   "email"
    t.string   "phone"
    t.string   "name"
    t.string   "access_token"
    t.datetime "last_signin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["access_token"], name: "index_users_on_access_token"
  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["facebook_uid"], name: "index_users_on_facebook_uid"

end