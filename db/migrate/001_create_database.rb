class CreateDatabase < ActiveRecord::Migration
  def self.up
    
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
 
  def self.down
  drop_table "authorizations"	
  drop_table "ca_managements"
  drop_table "prep_area_limits"
  drop_table "service_roles"
  drop_table "sessions"
  drop_table "tlps"
  end

end
