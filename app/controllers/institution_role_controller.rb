class InstitutionRoleController < ApplicationController

  def index
    @institution_roles = InstitutionRole.find_by_role_id(params[:role])
  end

  def user_index
    @user   = User.find_by_user_id(params[:on_behalf_of])
  end

  def edit #edit_role
    @institution_role = InstitutionRole.find_by_user_id()
  end

  def new
    @institution_role.create
  end

  def update
    @institution_role = InstitutionRole.find_by_user_id()
    @institution_role = InstitutionRole.update(params)
  end

  def delete
    logger.info 'Delete self service user, user: '+session[:user]+', delete user: '+params[:portal_id]
    @institution_role = InstitutionRole.find(:first, :conditions => "portal_id = '"+params[:portal_id]+"'")
    @institution_role.destroy
    redirect_to(:action=>"index")
  end
end
