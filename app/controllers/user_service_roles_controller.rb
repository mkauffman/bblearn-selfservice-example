class UserServiceRolesController < ApplicationController

  def index
    @user_service_roles = UserServiceRole.all
  end

  def new
    @user_service_role  = UserServiceRole.new
    @service_roles      = ServiceRole.all
  end

  def edit
    @user_service_role  = UserServiceRole.find(params[:id])
  end

  def create
    @user_service_role            = UserServiceRole.new
    @user_service_role.users_pk1  = User.find_by_user_id(params[:user][:user_id]).pk1
    @user_service_role.role_id    = params[:user_service_role][:role_id]

    if @user_service_role.save
      redirect_to(user_service_roles_url, :notice => 'Service Role assignment was successfully created.')
    else
      render :action => "index"        
    end    
  end

  def update
    @user_service_role = UserServiceRole.find(params[:id])

    if @user_service_role.update_attributes(params[:user_service_role])
      redirect_to(user_service_roles_url, :notice => 'Service Role assignment was successfully updated.')
    else
      render :action => "edit"
    end    
  end

  def destroy
    @user_service_role = UserServiceRole.find(params[:id])
    @user_service_role.destroy

    redirect_to(user_service_roles_url)
  end
end
