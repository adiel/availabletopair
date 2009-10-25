# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091023233000) do

  create_table "availabilities", :force => true do |t|
    t.string   "developer"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "contact"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "project"
  end

  add_index "availabilities", ["developer", "start_time", "end_time"], :name => "availabilities_pair_search_index"
  add_index "availabilities", ["developer"], :name => "availabilities_name_index"

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :null => false
    t.string  "server_url"
    t.string  "salt",       :null => false
  end

  create_table "pair", :force => true do |t|
    t.integer  "availability_id"
    t.integer  "available_pair_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "developer"
    t.string   "project"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "contact"
  end

  add_index "pair", ["availability_id"], :name => "pairs_availability_id_index"

end
