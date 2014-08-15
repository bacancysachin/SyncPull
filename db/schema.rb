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

ActiveRecord::Schema.define(version: 20140815090547) do

  create_table "properties", force: true do |t|
    t.string   "request_id"
    t.datetime "requested_at"
    t.float    "lat",                        limit: 24
    t.float    "lng",                        limit: 24
    t.integer  "year_built"
    t.string   "usecode"
    t.datetime "last_sold_on"
    t.float    "last_sold_price",            limit: 24
    t.integer  "tax_assesment_year"
    t.float    "tax_assesment_amount",       limit: 24
    t.float    "zestimate_price",            limit: 24
    t.integer  "zestimate_value_range_high"
    t.integer  "zestimate_value_range_low"
    t.datetime "zastimate_last_updated_on"
    t.integer  "lot_size"
    t.integer  "house_size"
    t.integer  "zpid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "properties", ["lat", "lng", "request_id"], name: "index_properties_on_lat_and_lng_and_request_id", using: :btree

end
