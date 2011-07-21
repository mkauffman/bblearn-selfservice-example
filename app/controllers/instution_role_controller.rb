class InstitutionRoleController < ApplicationController
  before_filter do |c|
    c.send(:is_authorized, [:super, :admin])
  end

  def index
    @institution_roles = InstitutionRole.all
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

  def user_doesnt_exist
  end

  def user_already_exists
  end

  ################################### Private Functions ####################################
  private
  def chk_db
    begin
      Role.find(:first)
    rescue
      redirect_to(:controller => "selfservice", :action => "db_down") and return
    end
    return true
  end # chk_db

  def submit_chk
    unless params[:commit]=="Create" or params[:commit]=="Update"
      redirect_to(:action=>"index") and return
    else
      return true
    end # unless commit
  end # submit_chk

  def filter(*params)
    problem = false
    params = params.flatten
    for param in params
      reg_filter = Regexp.new('[^-_,@\s:A-Za-z0-9]')
      if reg_filter.match(param)
        problem = true
      end # if match
    end # for param
    if problem
      redirect_to(:controller => "selfservice", :action => "problem") and return
    else
      return true
    end # if problem
  end # filter

  def exist_chk
    unless Person.check_user_id_existence(params[:portal])
      redirect_to(:action=>"user_doesnt_exist") and return
    else
      return true
    end
  end # exist_chk
end

