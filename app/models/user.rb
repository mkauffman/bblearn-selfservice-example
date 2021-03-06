class User < ActiveRecord::Base
  establish_connection "oracle_#{RAILS_ENV}"
  set_table_name "#{AppConfig.bbl_db_table}.USERS"
  set_primary_key "pk1"
  has_many :section_roles, :foreign_key => "users_pk1"
  has_many :sections, :through => :course_roles, :foreign_key => "users_pk1"
  has_many :user_roles, :foreign_key => "users_pk1"
  has_many :institution_roles, :through => :user_roles, :foreign_key => "users_pk1"

  #Blackboard has two role types, primary and secondary. The primary role
  #is attached the User table, and the secondary roles are stored in another
  #table. A user can have one primary and many secondaries. The point of
  #this code is retrieve all the roles the user has, regardless of primary
  #or secondary.

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
  
  def admin?
    self.all_roles.each do |r|
      if r.role_id == "admin"
        return true
      end
    end
    false
  end

  #TODO: The ContextWS.new initializes the webservice call.
  #It returns a token value that will be used during any
  #other calls. All the code before "user_service" should be
  #moved into a library method to improve DRY functionality
  #through the code. You'll see those four start lines repeated
  #often throughout the code.

  def save!

    con           = ContextWS.new
    token         = con.ws
    
    con.login_tool
    con.emulate_user
    
    user_service  = UserWS.new(token)
    user_service.ws
    
    user = self.attributes.to_options!
    
    user_service.save(user)
    
  end

  def allowed?(controller,action) 
    return false if self.all_roles.nil?
    self.all_roles.each do |r|    
      if r.allowed?(controller,action)
        return true
      end
    end
    false
  end

  #This method defines which role is used for sso sign in.
  
  def sso_role
    role = nil
    self.all_roles.each do |r|      
      if r.allowed?('sso','designer') || r.allowed?('sso', 'student')
        role = r
      end
      role = r if r.allowed?('sso','admin')
    end
    role
  end

end

