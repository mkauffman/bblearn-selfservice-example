class User < ActiveRecord::Base
  establish_connection :oracle_development
  set_table_name "BBLEARN2.USERS"
  set_primary_key "pk1"
  has_many :section_roles, :foreign_key => "users_pk1"
  has_many :sections, :through => :course_roles, :foreign_key => "users_pk1"
  has_many :user_roles, :foreign_key => "users_pk1"
  has_many :institution_roles, :through => :user_roles, :foreign_key => "users_pk1"

  def all_roles
    roles = Array.new
    roles << InstitutionRole.find(self.institution_roles_pk1)
    self.institution_roles.each do |r|
      roles << r
    end
    return roles
  end

  def clicker
    clicker = Tpextract.find_by_bb_user_id(self.user_id)
  end

end

