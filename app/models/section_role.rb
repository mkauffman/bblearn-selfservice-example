require 'context_ws'
require 'section_role_ws'

class SectionRole < ActiveRecord::Base
  establish_connection "oracle_#{RAILS_ENV}"
  set_table_name "#{AppConfig.bbl_db_table}.COURSE_USERS"
  set_primary_key "pk1"
  belongs_to :user, :foreign_key => "users_pk1"
  belongs_to :section, :foreign_key => "crsmain_pk1"

   def self.find_all_preparea_roles_for_user_pk1(user_pk1)
    prep_section_roles  = []
    prep_find           = /PrepArea-(.+)/
    section_roles       = self.find_all_by_users_pk1_and_role(user_pk1, 'P')

    section_roles.each do |s|
      if prep_find.match(s.section.course_id)
        prep_section_roles << s
      end
    end
    return prep_section_roles
   end

  def destroy
    con             = ContextWS.new
    token           = con.ws
    con.login_tool
    con.emulate_user
    section_role_ws = SectionRoleWS.new(token)
    section_role_ws.ws
    section_role_ws.delete_course_membership(role)
  end

  def self.create(crsmain_pk1, users_pk1, role_id)
    con             = ContextWS.new
    token           = con.ws
    con.login_tool
    con.emulate_user
    section_role_ws = SectionRoleWS.new(token)
    section_role_ws.ws
    section_role_ws.save_course_membership  :crsmain_pk1 => crsmain_pk1,
                                            :users_pk1 => users_pk1,
                                            :role_id => role_id
  end

  def self.find_by_id_comparison(slave,master)
    slave_set  = Section.find(:all, :joins => :section_roles, :conditions => ["users_pk1 = ?", slave])
    master_set = Section.find(:all, :joins => :section_roles, :conditions => ["users_pk1 = ?", master])

    return slave_set.to_a - (slave_set.to_a & master_set.to_a)
  end

  
end

