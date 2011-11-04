class ServiceRole < ActiveRecord::Base
  has_many :athorizations, :dependent => :delete_all
  has_one :user, :foreign_key => :users_pk1
  validates_uniqueness_of :users_pk1
  
  
  def blackboard_check
    if InstitutionRole.find_by_role_id(self.name).nil?
      false
    else
      true
    end
  end
  
  def allowed?(controller,action)
    ca    = CAManagement.find_by_controller_and_action(controller,action)
    auth  = Authorization.find_by_ca_management_id_and_service_role_id(ca.id,self.id)
    auth.allowed
  end
end
