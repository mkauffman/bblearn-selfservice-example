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

ActiveRecord::Schema.define(:version => 20120508194138) do

  create_table "authorizations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ca_management_id"
    t.boolean  "allowed"
    t.string   "role_name"
  end

  create_table "ca_managements", :force => true do |t|
    t.string   "controller"
    t.string   "action"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_models", :force => true do |t|
    t.string   "course_id"
    t.string   "friendly_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  create_table "prep_area_limits", :force => true do |t|
    t.string   "role"
    t.integer  "limit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "service_roles", :force => true do |t|
    t.string   "name"
    t.integer  "institution_role_pk1"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "tlps", :force => true do |t|
    t.text     "html_type"
    t.text     "html"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
