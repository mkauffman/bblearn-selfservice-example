class Section < ActiveRecord::Base
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
     return sections
   end

   def self.create_prep_area(user_id, name)
      course_id       = name.strip.gsub(" ","-")
      prefix          = "PrepArea-"+user_id+"-"
      prep_course_id  = prefix+course_id
      prep_name       = prefix+name
      section_web_service.create_course :course_id  => prep_course_id,
                                        :name       => prep_name
   end

   def self.create(name)
      course_id      = name.strip.gsub(" ","-")
      section_web_service.create_course :course_id  => course_id,
                                        :name       => name
   end

  def destroy
    #section = self.attributes.to_options
    section_web_service.delete_course :pk1 => self.pk1
  end

  def update
    section_web_service.update_course(section)
  end
  
private

  def section_web_service
      con            = ContextWS.new
      token          = con.ws
      con.login_tool
      con.emulate_user
      ws_section = SectionWS.new(token)
      ws_section.ws
      ws_section
  end
end

