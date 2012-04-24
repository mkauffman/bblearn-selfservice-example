class InstitutionRolesController < ApplicationController

  def index
    @institution_role = InstitutionRole.find_by_role_id(params[:role])
    @user_roles       = @institution_role.user_roles
    @users            = User.find_all_by_institution_roles_pk1(@institution_role.pk1)
    @user_roles.each {|ur| @users << ur.user}
  end

  def user_index
    @user   = User.find_by_user_id(params[:user_id])
  end

  def edit
    # @institution_role = InstitutionRole.find_by_user_id()
  end

  def new
    # @institution_role.create
  end

  def update
    # @institution_role = InstitutionRole.find_by_user_id()
    # @institution_role = InstitutionRole.update(params)
  end

  def delete
    # logger.info 'Delete self service user, user: '+session[:user]+', delete user: '+params[:portal_id]
    # @institution_role = InstitutionRole.find(:first, :conditions => "portal_id = '"+params[:portal_id]+"'")
    # @institution_role.destroy
    # redirect_to(:action=>"index")
  end
end
