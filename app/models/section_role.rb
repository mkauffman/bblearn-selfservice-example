require 'context_ws'
require 'section_role_ws'

class SectionRole < ActiveRecord::Base
  establish_connection :oracle_development
  set_table_name "BBLEARN2.COURSE_USERS"
  set_primary_key "pk1"
  belongs_to :user, :foreign_key => "users_pk1"
  belongs_to :section, :foreign_key => "crsmain_pk1"

  def self.destroy(section_role, crsmain_pk1)
    con   = ContextWS.new
    token = con.ws
    con.login_tool
    con.emulate_user
    sr    = SectionRoleWS.new(token)
    sr.ws
    sr.delete_course_membership :pk1 => section_role,
                                :crsmain_pk1 => crsmain_pk1
  end
  
  def self.create(crsmain_pk1, users_pk1, role_id)
    con   = ContextWS.new
    token = con.ws
    con.login_tool
    con.emulate_user
    sr    = SectionRoleWS.new(token)
    sr.ws
    sr.save_course_membership   :crsmain_pk1 => crsmain_pk1,
                                :users_pk1 => users_pk1,
                                :role_id => role_id
  end

  def self.find_by_id_comparison(slave,master)
    slave_set  = Section.find(:all, :joins => :section_roles, :conditions => ["users_pk1 = ?", slave])
    master_set = Section.find(:all, :joins => :section_roles, :conditions => ["users_pk1 = ?", master])

    return slave_set.to_a - (slave_set.to_a & master_set.to_a)
  end

end

