class InstitutionRoleController < ApplicationController

  def index
    @institution_roles = UserRole.all
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
