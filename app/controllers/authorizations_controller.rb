class AuthorizationsController < ApplicationController

  
  def index
    @ca_managements     = CAManagement.all
    @service_roles      = ServiceRole.all
    @institution_roles  = InstitutionRole.all
    @authorizations     = Authorization.all
  end

  def update
    if update_authorizations
      redirect_to(authorizations_url, :notice => 'Authorizations were successfully updated.')
    else
      redirect_to(authorizations_url, :notice => 'Authorizations were not updated')
    end
  end
  
  private
  
  def update_authorizations
    controller_actions  = CAManagement.all
    roles               = ServiceRole.all
    
    controller_actions.each do |ca|
      roles.each do |r|
        auth          = Authorization.find_by_ca_management_id_and_role_name(ca.id,r.name) 
        auth.allowed  = params[ca.full_title.to_sym][r.name.to_sym]        
        unless auth.save
          return false
        end
      end
    end
    true
  end
  
  
end
