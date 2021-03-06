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

ActiveRecord::Schema.define(version: 20151108173142) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "recipients", force: :cascade do |t|
    t.string   "phone_number"
    t.string   "email"
    t.integer  "secret_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
  end

  add_index "recipients", ["secret_id"], name: "index_recipients_on_secret_id", using: :btree
  add_index "recipients", ["token"], name: "index_recipients_on_token", using: :btree

  create_table "secrets", force: :cascade do |t|
    t.text     "encrypted_body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encryption_salt"
    t.integer  "decryption_attempt", default: 0
    t.datetime "expiry"
  end

  create_table "senders", force: :cascade do |t|
    t.string   "email"
    t.string   "token"
    t.integer  "secret_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "senders", ["secret_id"], name: "index_senders_on_secret_id", using: :btree
  add_index "senders", ["token"], name: "index_senders_on_token", using: :btree

end
