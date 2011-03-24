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

ActiveRecord::Schema.define(:version => 20110125180512) do

  create_table "dbsessions", :force => true do |t|
    t.string   "session_number"
    t.string   "section_id"
    t.string   "section_type"
    t.string   "section_parent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", :force => true do |t|
    t.string   "source"
    t.string   "member_source"
    t.string   "member_id"
    t.string   "member_user_id"
    t.string   "id_type"
    t.string   "rec_status"
    t.string   "role_type"
    t.string   "status"
    t.string   "sub_role"
    t.string   "datasource"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.string   "sourced_id"
    t.string   "source"
    t.string   "empl_id"
    t.string   "webct_id"
    t.string   "full_name"
    t.string   "last_name"
    t.string   "first_name"
    t.string   "name_prefix"
    t.string   "name_suffix"
    t.string   "nickname"
    t.string   "email"
    t.string   "datasource"
    t.string   "is_mail_forwarded"
    t.string   "role"
    t.string   "primary"
    t.string   "status"
    t.string   "password"
    t.string   "rec_status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "portal_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sections", :force => true do |t|
    t.string   "source"
    t.string   "lc_id"
    t.string   "course_id"
    t.string   "section_id"
    t.string   "short_name"
    t.string   "long_name"
    t.string   "full_name"
    t.string   "timeframe_begin"
    t.string   "timeframe_restrict_begin"
    t.string   "timeframe_end"
    t.string   "timeframe_restrict_end"
    t.string   "accept_enrollment"
    t.string   "datasource"
    t.string   "parent_source"
    t.string   "parent_id"
    t.string   "template_parent_id"
    t.string   "template_parent_source"
    t.string   "template_zip_or_epk_path"
    t.string   "template_none"
    t.string   "delivery_unit_type"
    t.string   "term_name"
    t.string   "term_id"
    t.string   "admin_period"
    t.string   "term_datasource"
    t.string   "primary_instructor_name"
    t.string   "primary_instructor_id"
    t.string   "admin_xlist_sect_type"
    t.string   "level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "selfservices", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "portal_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "terms", :force => true do |t|
    t.string   "term_id"
    t.string   "new_term_id"
    t.integer  "start_date"
    t.integer  "end_date"
    t.string   "description"
    t.boolean  "current_term"
    t.string   "old_term_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tlps", :force => true do |t|
    t.text     "html_type"
    t.text     "html"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
