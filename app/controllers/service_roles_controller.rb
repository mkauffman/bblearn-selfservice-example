class ServiceRolesController < ApplicationController

  def index
    @service_roles = ServiceRole.all
  end


  def show
    @service_role = ServiceRole.find(params[:id])
  end


  def new
    @service_role = ServiceRole.new
  end


  def edit
    @service_role = ServiceRole.find(params[:id])
  end


  def create
    @service_role = ServiceRole.new(params[:service_role])

    if @service_role.save
      caction  = CAManagement.all
      caction.each do |ca|
        auth                  = Authorization.new
        auth.ca_management_id = ca.id
        auth.service_role_id  = @service_role.instition_roles_pk1
        auth.allowed          = false
        auth.save
      end
      redirect_to(@service_role, :notice => 'Self Service Role was successfully created.') 
    else
      render :xml => @service_role.errors, :status => :unprocessable_entity 
    end      
  end


  def update
    @service_role = ServiceRole.find(params[:id])
    
    if @service_role.update_attributes(params[:service_role])
      redirect_to(@service_role, :notice => 'Self Service Role was successfully updated.') 
    else
      render :action => "edit" 
    end
  end

  def destroy
    @service_role = ServiceRole.find(params[:id])
    @service_role.destroy

    redirect_to(service_roles_url)    
  end
  
end
