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

ActiveRecord::Schema.define(:version => 20111110215819) do

  create_table "authorizations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ca_management_id"
    t.boolean  "allowed"
    t.integer  "institution_roles_pk1"
  end

  create_table "bbl_contexts", :force => true do |t|
    t.string   "user_to_emulate"
    t.string   "additional_seconds"
    t.string   "userid"
    t.string   "method"
    t.string   "password"
    t.string   "client_vendor_id"
    t.string   "client_program_id"
    t.string   "login_extra_info"
    t.string   "expected_life_seconds"
    t.string   "ticket"
    t.string   "client"
    t.string   "session_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "logged_in"
  end

  create_table "bbl_course_memberships", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bbl_courses", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bbl_users", :force => true do |t|
    t.string   "birth_date"
    t.string   "datasource_id"
    t.string   "education_level"
    t.string   "expansion_data"
    t.string   "business_fax"
    t.string   "business_phone_1"
    t.string   "business_phone_2"
    t.string   "city"
    t.string   "company"
    t.string   "country"
    t.string   "department"
    t.string   "email"
    t.string   "family_name"
    t.string   "given_name"
    t.string   "home_fax"
    t.string   "home_phone_1"
    t.string   "home_phone_2"
    t.string   "job_title"
    t.string   "middle_name"
    t.string   "mobile_phone"
    t.string   "state"
    t.string   "street_1"
    t.string   "street_2"
    t.string   "web_page"
    t.string   "zip_code"
    t.string   "gender"
    t.string   "ins_roles"
    t.string   "is_available"
    t.string   "name"
    t.string   "password"
    t.string   "student_id"
    t.string   "system_roles"
    t.string   "title"
    t.string   "user_batch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ca_managements", :force => true do |t|
    t.string   "controller"
    t.string   "action"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dbsessions", :force => true do |t|
    t.string   "session_number"
    t.string   "section_id"
    t.string   "section_type"
    t.string   "section_parent"
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
    t.string   "student_list_file_name"
    t.string   "student_list_content_type"
    t.integer  "student_list_file_size"
    t.datetime "student_list_updated_at"
    t.string   "status"
  end

  create_table "service_roles", :force => true do |t|
    t.string   "name"
    t.integer  "institution_role_pk1"
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
