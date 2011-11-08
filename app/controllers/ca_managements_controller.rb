#TODO: Add sidebar allowed checks
#TODO: Create module for exporting and importing data.
#TODO: Fix SSO inputs

class CaManagementsController < ApplicationController

  def index
    @ca_managements = CAManagement.all
  end

  def show
    @ca_management = CAManagement.find(params[:id])
  end

  def new
    @ca_management = CAManagement.new    
  end

  def edit
    @ca_management = CAManagement.find(params[:id])
  end

  def create
    @ca_management = CAManagement.new(params[:ca_management])
    
    if @ca_management.save
      s_roles = ServiceRole.all
      s_roles.each do |sr|
        auth                  = Authorization.new
        auth.ca_management_id = @ca_management.id
        auth.service_role_id  = sr.id
        auth.allowed          = false
        auth.allowed          = true if sr.name == "admin"
        auth.save
      end
      redirect_to(@ca_management, :notice => 'CAManagement was successfully created.')
    else
      render :action => "new"
    end    
  end

  def update
    @ca_management = CAManagement.find(params[:id])

    if @ca_management.update_attributes(params[:ca_management])
      redirect_to(@ca_management, :notice => 'CAManagement was successfully updated.')
    else
      render :action => "edit"
    end      
  end

  def destroy
    @ca_management = CAManagement.find(params[:id])
    @ca_management.destroy

    redirect_to(ca_managements_url)    
  end
  
end
