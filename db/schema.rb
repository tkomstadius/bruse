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

ActiveRecord::Schema.define(version: 20150312104627) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bruse_files", force: :cascade do |t|
    t.string   "name"
    t.integer  "identity_id"
    t.string   "foreign_ref"
    t.string   "filetype"
    t.string   "meta"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "download_hash"
  end

  create_table "bruse_files_tags", force: :cascade do |t|
    t.integer "bruse_file_id"
    t.integer "tag_id"
  end

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "token"
    t.string   "service"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "uid"
    t.string   "name"
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trigrams", force: :cascade do |t|
    t.string  "trigram",     limit: 3
    t.integer "score",       limit: 2
    t.integer "owner_id"
    t.string  "owner_type"
    t.string  "fuzzy_field"
  end

  add_index "trigrams", ["owner_id", "owner_type", "fuzzy_field", "trigram", "score"], name: "index_for_match", using: :btree
  add_index "trigrams", ["owner_id", "owner_type"], name: "index_by_owner", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "name"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "sign_in_count",   default: 0
    t.datetime "last_sign_in_at"
  end

  add_foreign_key "identities", "users"
end
