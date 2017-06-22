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

ActiveRecord::Schema.define(version: 20170622005608) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "assignments", force: :cascade do |t|
    t.integer  "team_id"
    t.uuid     "user_id"
    t.integer  "hours"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "days", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "user_id",                                                      null: false
    t.date     "date",                                                         null: false
    t.decimal  "client_hours",         precision: 4, scale: 2, default: 0.0,   null: false
    t.decimal  "internal_hours",       precision: 4, scale: 2, default: 0.0,   null: false
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
    t.boolean  "pto",                                          default: false, null: false
    t.boolean  "timer_reminder_sent",                          default: false, null: false
    t.boolean  "tracked_in_real_time",                         default: false, null: false
    t.boolean  "workday",                                      default: false, null: false
    t.jsonb    "hours",                                        default: {},    null: false
  end

  add_index "days", ["date"], name: "index_days_on_date", using: :btree
  add_index "days", ["hours"], name: "index_days_on_hours", using: :gin
  add_index "days", ["user_id"], name: "index_days_on_user_id", using: :btree

  create_table "months", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "user_id",                                                          null: false
    t.decimal  "client_hours",               precision: 5, scale: 2, default: 0.0, null: false
    t.decimal  "internal_hours",             precision: 5, scale: 2, default: 0.0, null: false
    t.datetime "created_at",                                                       null: false
    t.datetime "updated_at",                                                       null: false
    t.integer  "year",                                                             null: false
    t.integer  "number",                                                           null: false
    t.integer  "day_count",                                          default: 0,   null: false
    t.integer  "pto_count",                                          default: 0,   null: false
    t.integer  "timer_reminder_sent_count",                          default: 0,   null: false
    t.integer  "tracked_in_real_time_count",                         default: 0,   null: false
    t.integer  "workday_count",                                      default: 0,   null: false
  end

  add_index "months", ["number"], name: "index_months_on_number", using: :btree
  add_index "months", ["user_id"], name: "index_months_on_user_id", using: :btree
  add_index "months", ["year"], name: "index_months_on_year", using: :btree

  create_table "responsibilities", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "title"
    t.string   "adjective"
    t.text     "harvest_client_ids", default: [],    null: false, array: true
    t.boolean  "default",            default: false, null: false
    t.integer  "position"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "responsibilities", ["harvest_client_ids"], name: "index_responsibilities_on_harvest_client_ids", using: :gin
  add_index "responsibilities", ["position"], name: "index_responsibilities_on_position", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name",                        null: false
    t.integer  "hours",                       null: false
    t.boolean  "active",       default: true
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "project_id"
    t.string   "project_name"
  end

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name",                                              null: false
    t.string   "email",                                             null: false
    t.string   "harvest_id",                                        null: false
    t.string   "zenefits_name",                                     null: false
    t.string   "time_zone",                                         null: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "slack_id"
    t.string   "workdays",      default: ["1", "2", "3", "4", "5"], null: false, array: true
    t.boolean  "active",        default: true,                      null: false
    t.text     "tags",          default: [],                                     array: true
  end

  add_index "users", ["slack_id"], name: "index_users_on_slack_id", unique: true, using: :btree
  add_index "users", ["tags"], name: "index_users_on_tags", using: :gin

end
