class ServiceRole < ActiveRecord::Base
  has_many :athorizations, :dependent => :delete_all
  has_one :user, :foreign_key => :users_pk1
  has_one :user_service_role
  has_one :institution_role, :foreign_key => :institution_roles_pk1
  validates_uniqueness_of :users_pk1
  
  
  def blackboard_check
    if InstitutionRole.find_by_role_id(self.name).nil?
      false
    else
      true
    end
  end
  
  def allowed?(controller,action)
    i_role = InstitutionRole.find_by_role_id(self.name)
    i_role.allowed?(controller,action)
  end
  
  def institution_roles_pk1
    InstitutionRole.find_by_role_id(self.name).pk1
  end
  
end
