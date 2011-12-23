require 'webservices'

class Section < ActiveRecord::Base
  include Webservices
  establish_connection "oracle_#{RAILS_ENV}"
  set_table_name "#{AppConfig.bbl_db_table}.COURSE_MAIN"
  set_primary_key "pk1"
  has_many    :section_roles,                             :foreign_key => "crsmain_pk1"
  has_many    :users,         :through => :course_roles,  :foreign_key => "crsmain_pk1"
  belongs_to  :datasource,                                :foreign_key => 'data_src_pk1'
  set_integer_columns :row_status


   def self.find_all_prepareas_for_instructor_pk1(user_pk1)
     sections   = []
     prep_roles = SectionRole.find_all_preparea_roles_for_user_pk1(user_pk1)
     prep_roles.each do |p|
       sections << p.section
     end
     return sections
   end

   def self.find_all_for_instructor_pk1(user_pk1)
     sections   = []
     roles      = SectionRole.find_all_by_users_pk1_and_role(user_pk1, 'ci')
     roles.each do |p|
       sections << p.section
     end
     sections
   end

   def self.create_prep_area(user_id, name)
      course_id       = name.strip.gsub(" ","-")
      prefix          = "PrepArea-"+user_id+"-"
      prep_course_id  = prefix+course_id
      prep_name       = prefix+name

      con             = ContextWS.new
      token           = con.ws
      con.login_tool
      con.emulate_user
      ws_section = SectionWS.new(token)
      ws_section.ws
      ws_section.create_course  :course_id  => prep_course_id,
                                :course_name       => prep_name
   end

  def self.create(name)
      course_id      = name.strip.gsub(" ","-")
      con             = ContextWS.new
      token           = con.ws
      con.login_tool
      con.emulate_user
      ws_section = SectionWS.new(token)
      ws_section.ws
      ws_section.create_course :course_id   => course_id,
                               :course_name => name
  end

  def save!
    con         = ContextWS.new
    token       = con.ws
    con.login_tool
    con.emulate_user

    ws_section  = SectionWS.new(token)
    ws_section.ws
    ws_section.create_course self.attributes.to_options
  end


  def destroy
    #section = self.attributes.to_options
    con             = ContextWS.new
    token           = con.ws
    con.login_tool
    con.emulate_user
    ws_section = SectionWS.new(token)
    ws_section.ws
    ws_section.delete_course :pk1 => self.pk1
  end

  def update
    con             = ContextWS.new
    token           = con.ws
    con.login_tool
    con.emulate_user
    ws_section = SectionWS.new(token)
    ws_section.ws
    ws_section.update_course(section)
  end

end

