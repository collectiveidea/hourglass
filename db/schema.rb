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

ActiveRecord::Schema.define(version: 20140113233449) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "date_totals", force: true do |t|
    t.date     "date"
    t.decimal  "billable_hours", precision: 5, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "days", force: true do |t|
    t.integer  "project_id"
    t.date     "date"
    t.decimal  "hours",      precision: 5, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "days", ["date"], name: "index_days_on_date", using: :btree
  add_index "days", ["project_id", "date"], name: "index_days_on_project_id_and_date", unique: true, using: :btree

  create_table "projects", force: true do |t|
    t.string   "name"
    t.integer  "harvest_id"
    t.integer  "expected_weekly_hours"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
