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

ActiveRecord::Schema.define(version: 20170507134949) do

  create_table "delayed_jobs", force: :cascade do |t|
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
    t.string   "signature"
    t.text     "args"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "gifts", force: :cascade do |t|
    t.integer  "list_id"
    t.integer  "user_id"
    t.string   "name"
    t.text     "description"
    t.string   "price_range"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["list_id"], name: "index_gifts_on_list_id"
    t.index ["user_id"], name: "index_gifts_on_user_id"
  end

  create_table "invitation_lists", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "list_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["list_id"], name: "index_invitation_lists_on_list_id"
    t.index ["user_id"], name: "index_invitation_lists_on_user_id"
  end

  create_table "lists", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "occasion"
    t.string   "occasion_of"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.date     "occasion_date"
    t.string   "occasion_data"
    t.text     "invitation_text"
    t.text     "welcome_text"
    t.index ["user_id"], name: "index_lists_on_user_id"
  end

  create_table "urls", force: :cascade do |t|
    t.integer  "gift_id"
    t.string   "digest"
    t.string   "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gift_id"], name: "index_urls_on_gift_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.integer  "role"
    t.string   "name"
    t.string   "surname"
    t.integer  "sex"
    t.date     "dob"
    t.date     "birth_year"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
