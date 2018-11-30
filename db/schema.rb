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

ActiveRecord::Schema.define(version: 20170907115156) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "addresses", force: :cascade do |t|
    t.string   "street"
    t.string   "street_number"
    t.string   "zip_code"
    t.string   "city"
    t.string   "country"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "telephone"
    t.string   "telephone_normalized"
    t.string   "email"
    t.string   "addressable_type"
    t.integer  "addressable_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "bookings", force: :cascade do |t|
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "telephone"
    t.string   "email"
    t.integer  "restaurant_id"
    t.integer  "package_id"
    t.integer  "persons"
    t.string   "telephone_normalized"
    t.text     "notes"
    t.string   "name"
    t.string   "status"
    t.string   "token",                null: false
    t.datetime "notified_at"
    t.datetime "at"
    t.text     "personal_message"
    t.string   "slug"
    t.integer  "city_id"
  end

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "bookable_from"
  end

  create_table "city_packages", force: :cascade do |t|
    t.integer  "package_id"
    t.integer  "city_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "codes", force: :cascade do |t|
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "code"
    t.datetime "activated_at"
    t.integer  "booking_id"
  end

  create_table "coupon_redemptions", force: :cascade do |t|
    t.integer "booking_id"
    t.integer "coupon_id"
  end

  add_index "coupon_redemptions", ["booking_id", "coupon_id"], name: "index_coupon_redemptions_on_booking_id_and_coupon_id", using: :btree

  create_table "coupons", force: :cascade do |t|
    t.string  "code"
    t.integer "discount_percentage"
    t.date    "expires_at"
  end

  add_index "coupons", ["code"], name: "index_coupons_on_code", using: :btree

  create_table "faqs", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.boolean  "published"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "meeting_points", force: :cascade do |t|
    t.string "name"
    t.text   "description"
  end

  create_table "package_deals", force: :cascade do |t|
    t.integer  "restaurant_id"
    t.integer  "package_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "price_cents",    default: 0,     null: false
    t.string   "price_currency", default: "EUR", null: false
  end

  create_table "packages", force: :cascade do |t|
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
    t.boolean  "featured"
    t.string   "selling_points",      default: [],                 array: true
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "description"
    t.integer  "package_deals_count", default: 0
    t.integer  "price_cents",         default: 0,     null: false
    t.string   "price_currency",      default: "EUR", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "booking_id"
    t.string   "mollie_payment_id"
    t.string   "mollie_payment_url"
    t.string   "token"
    t.string   "payment_status"
    t.datetime "paid_at"
    t.integer  "amount_cents",       default: 0,     null: false
    t.string   "amount_currency",    default: "EUR", null: false
  end

  create_table "restaurants", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "name"
    t.integer  "meeting_point_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "number_of_packages", default: 0
    t.string   "iban"
    t.string   "bic"
  end

  create_table "reviews", force: :cascade do |t|
    t.text     "quote"
    t.string   "name"
    t.boolean  "featured",           default: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "scheduled_jobs", force: :cascade do |t|
    t.string   "job_id"
    t.string   "job_name"
    t.datetime "at"
    t.json     "args"
    t.integer  "schedulable_id"
    t.string   "schedulable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settlement_batches", force: :cascade do |t|
    t.string   "name"
    t.datetime "settled_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "xml"
  end

  create_table "settlements", force: :cascade do |t|
    t.integer  "booking_id"
    t.integer  "restaurant_id"
    t.integer  "settlement_batch_id"
    t.integer  "total_amount_cents",    default: 0,     null: false
    t.string   "total_amount_currency", default: "EUR", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
