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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110911090032) do

  create_table "availabilities", :force => true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "project"
    t.integer  "user_id"
  end

  add_index "availabilities", ["start_time", "end_time"], :name => "altered_availabilities_pair_search_index"

  create_table "availabilities_tags_links", :force => true do |t|
    t.integer "availability_id", :null => false
    t.integer "tag_id",          :null => false
  end

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
    t.string   "tags"
  end

  add_index "pairs", ["availability_id"], :name => "altered_pairs_availability_id_index"

  create_table "tags", :force => true do |t|
    t.string   "tag",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "contact"
    t.string   "username"
  end

end
