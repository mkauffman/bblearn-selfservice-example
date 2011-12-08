class ServiceRole < ActiveRecord::Base
  #has_many :authorizations, :dependent => :delete_all
  belongs_to :user, :foreign_key => :users_pk1
  #validates_uniqueness_of :users_pk1
  
  
  def blackboard_check
    if InstitutionRole.find_by_role_id(self.name).nil?
      false
    else
      true
    end
  end
  
  def allowed?(controller,action)
    i_role = InstitutionRole.find_by_role_id(self.name)
    return false if InstitutionRole.find_by_role_id(self.name).nil?
    i_role.allowed?(controller,action)
  end
  
  def institution_roles
    i_role = InstitutionRole.find_by_role_id(self.name)
  end
  
end
