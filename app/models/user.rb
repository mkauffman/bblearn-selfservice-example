class User < ActiveRecord::Base
  establish_connection "oracle_#{RAILS_ENV}"
  set_table_name "#{AppConfig.bbl_db_table}.USERS"
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

  def self.create(user_id)
    # TODO: determine better values for mandatory fields:
    last_name   = "User"
    first_name  = "SSO"
    password    = "tryingtest"

    con   = ContextWS.new
    token = con.ws
    con.login_tool
    con.emulate_user
    use   = UserWS.new(token)
    use.ws
    use.save        :fam_name    => last_name,
                    :given_name   => first_name,
                    :student_id   => user_id,
                    :name         => user_id,
                    :password     => password
  end


end

