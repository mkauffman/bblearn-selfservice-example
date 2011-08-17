class Section < ActiveRecord::Base
  establish_connection "oracle_#{RAILS_ENV}"
  set_table_name "#{AppConfig.bbl_db_table}.COURSE_MAIN"
  set_primary_key "pk1"
  has_many :section_roles, :foreign_key => "crsmain_pk1"
  has_many :users, :through => :course_roles, :foreign_key => "crsmain_pk1"



   def self.find_by_instructor_id(instructor_id)
      section_roles = SectionRole.find(:all,
          :conditions =>
          ['users_pk1 = :pk1 and role = P', {:id => instructor_id}])
      sections = []
      section_roles.each do |s|
          sections << s.section
      end
      return sections
   end

   def self.create(course_id)
    con   = ContextWS.new
    token = con.ws
    con.login_tool
    con.emulate_user
    sec   = SectionWS.new(token)
    sec.ws
    sec.create_course :course_id => course_id,
                      :name => course_id
   end

   def self.destroy(pk1)
    con   = ContextWS.new
    token = con.ws
    con.login_tool
    con.emulate_user
    sec   = SectionWS.new(token)
    sec.ws
    sec.delete_course :pk1 => pk1

   end

end

