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

ActiveRecord::Schema.define(version: 20160630060131) do

  create_table "datatypes", force: :cascade do |t|
    t.string   "name"
    t.string   "oid"
    t.string   "excludes"
    t.boolean  "table"
    t.string   "index_oid"
    t.string   "metric_type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.boolean  "derive"
  end

  create_table "datatypes_devices", id: false, force: :cascade do |t|
    t.integer "device_id",   null: false
    t.integer "datatype_id", null: false
  end

  add_index "datatypes_devices", ["datatype_id", "device_id"], name: "index_datatypes_devices_on_datatype_id_and_device_id"
  add_index "datatypes_devices", ["device_id", "datatype_id"], name: "index_datatypes_devices_on_device_id_and_datatype_id"

  create_table "devices", force: :cascade do |t|
    t.string   "devname"
    t.string   "city"
    t.string   "contact"
    t.string   "group"
    t.string   "address"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "query_interval"
    t.string   "snmp_community"
  end

end
