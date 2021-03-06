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

ActiveRecord::Schema.define(:version => 20110221100841) do

  create_table "chats", :force => true do |t|
    t.integer  "room"
    t.text     "message"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members", :force => true do |t|
    t.string   "name"
    t.boolean  "is_broadcaster"
    t.integer  "open_tok_session_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "open_tok_sessions", :force => true do |t|
    t.string   "session_title"
    t.string   "location",         :default => "127.0.0.1"
    t.boolean  "echo_suppression", :default => false
    t.boolean  "multiplexer",      :default => false
    t.integer  "output_streams"
    t.integer  "switch_type",      :default => 0
    t.integer  "switch_timeout",   :default => 5000
    t.string   "session_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description",      :default => ""
  end

end
