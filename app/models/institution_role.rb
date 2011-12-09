class InstitutionRole < ActiveRecord::Base
  establish_connection "oracle_#{RAILS_ENV}"
  set_table_name "#{AppConfig.bbl_db_table}.INSTITUTION_ROLES"
  set_primary_key "pk1"
  has_many :user_roles,     :foreign_key => "institution_roles_pk1"
  has_many :authorizations, :foreign_key => "institution_roles_pk1"
  
  
  def allowed?(controller,action)
    ca    = CAManagement.find_by_controller_and_action(controller,action)
    auth  = Authorization.find_by_ca_management_id_and_role_name(ca.id,self.role_id)
    
    return false if auth.nil?
    auth.allowed
  end
end

