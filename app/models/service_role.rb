class ServiceRole < ActiveRecord::Base
  #has_many :authorizations, :dependent => :delete_all
  belongs_to :user, :foreign_key => :users_pk1
  #validates_uniqueness_of :name
  
  
  def blackboard_check
    if InstitutionRole.find_by_role_id(self.name).nil?
      false
    else
      true
    end
  end
  
  def allowed?(controller,action)
    ca    = CAManagement.find_by_controller_and_action(controller,action)
    auth  = Authorization.find_by_ca_management_id_and_role_name(ca.id,self.name)
    
    return false if auth.nil?
    auth.allowed
  end
  
  def institution_roles
    i_role = InstitutionRole.find_by_role_id(self.name)
  end
  
end
