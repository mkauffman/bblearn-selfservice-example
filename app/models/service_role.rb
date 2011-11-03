class ServiceRole < ActiveRecord::Base
  has_many :athorizations, :dependent => :delete_all
  
  
  def blackboard_check
    if InstitutionRole.find_by_role_id(self.name).nil?
      false
    else
      true
    end
  end
  
  def allowed?(controller_action_id)
    auth = Authorization.find_by_ca_management_id_and_service_role_id(controller_action_id,self.id)
    auth.allowed
  end
end
