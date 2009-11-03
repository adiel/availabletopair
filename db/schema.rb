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

ActiveRecord::Schema.define(:version => 20091102351300) do

  create_table "availabilities", :force => true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "project"
    t.datetime "pairs_updated", :default => '2009-10-19 10:29:27'
    t.integer  "user_id"
  end

  add_index "availabilities", ["start_time", "end_time"], :name => "availabilities_pair_search_index"

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

  create_table "pairs", :force => true do |t|
    t.integer  "availability_id"
    t.integer  "available_pair_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "project"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "user_id"
    t.boolean  "accepted",          :default => false, :null => false
    t.boolean  "suggested",         :default => false, :null => false
  end

  add_index "pairs", ["availability_id"], :name => "pairs_availability_id_index"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "openid_identifier",                  :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "contact"
  end

end
