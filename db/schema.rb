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

ActiveRecord::Schema.define(version: 20140121093940) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "groups", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups_sites", force: true do |t|
    t.integer "site_id"
    t.integer "group_id"
  end

  create_table "items", force: true do |t|
    t.string   "name"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "standard_price"
  end

  add_index "items", ["name"], name: "index_items_on_name", using: :btree

  create_table "logs", force: true do |t|
    t.text     "message"
    t.string   "price_found"
    t.string   "name_found"
    t.string   "log_type"
    t.boolean  "ok"
    t.integer  "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", force: true do |t|
    t.decimal  "ban_time",      default: 24.0
    t.datetime "last_updated"
    t.string   "allowed_error", default: "5000.0"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "rate",          default: 9300.0
  end

  create_table "sites", force: true do |t|
    t.string   "name"
    t.string   "css_item"
    t.string   "css_price"
    t.string   "css_pagination", default: "no"
    t.text     "search_url"
    t.string   "method",         default: "2"
    t.string   "regexp",         default: "/d+/"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "standard"
    t.boolean  "violator",       default: false
    t.string   "email"
    t.string   "company_name"
  end

  add_index "sites", ["name"], name: "index_sites_on_name", using: :btree

  create_table "urls", force: true do |t|
    t.string   "url"
    t.decimal  "price"
    t.integer  "site_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "violator"
    t.decimal  "delta"
    t.boolean  "locked",     default: false
  end

  add_index "urls", ["item_id"], name: "index_urls_on_item_id", using: :btree
  add_index "urls", ["price"], name: "index_urls_on_price", using: :btree
  add_index "urls", ["site_id"], name: "index_urls_on_site_id", using: :btree
  add_index "urls", ["url"], name: "index_urls_on_url", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                  default: false
    t.string   "username"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
