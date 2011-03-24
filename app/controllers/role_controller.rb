class RoleController < ApplicationController
  before_filter do |c|
    c.send(:is_authorized, [:super, :admin])
  end
  
  def index
    if chk_db
      @roles = Role.all
    end # if chk_db
  end # index
  
  def edit_role
    if chk_db
      @role = Role.find(:first, :conditions => "portal_id = '"+params[:portal_id]+"'")
    end # if chk_db
  end # edit
  
  def new
    if chk_db: end # if chk_db
  end # new
  
  def create
    if chk_db
      if submit_chk
        if filter(params[:portal], params[:first_name], params[:last_name], params[:role])
          if exist_chk
            if Role.find(:first, :conditions => "portal_id = '"+params[:portal]+"'").nil?
              logger.info 'Creating new self service user, user: '+session[:user]+', new user: '+params[:portal]
              Role.create(:portal_id => params[:portal], :first_name => params[:first_name], 
                :last_name => params[:last_name] , :role => params[:role])
              redirect_to(:action=>"index") and return
            else
              redirect_to(:action => "user_already_exists") and return
            end # if Role
          end # exist_chk
        end # if filter
      end # if submit_chk
    end # if chk_db
  end # create
  
  def update
    if (chk_db)
      if (submit_chk)
        if (filter(params[:portal_id])) and (filter(params[:first_name])) and (filter(params[:last_name])) and (filter(params[:role]))
          logger.info 'Update self service user, user: '+session[:user]+', update user: '+params[:portal_id]
          role = Role.find(:first, :conditions => "portal_id = '"+params[:old_portal_id]+"'")
          role.update_attributes(:portal_id=>params[:portal_id], :first_name=>params[:first_name], :last_name=>params[:last_name], :role=>params[:role])
          redirect_to(:action=>"index") and return
        end # if filter
      end # if submit_chk
    end # if chk_db
  end # update
  
  def delete
    if (chk_db)
      logger.info 'Delete self service user, user: '+session[:user]+', delete user: '+params[:portal_id]
      @role = Role.find(:first, :conditions => "portal_id = '"+params[:portal_id]+"'")
      @role.destroy
      
      redirect_to(:action=>"index")
    end # if chk_db
  end # destroy
  
  def user_doesnt_exist
  end # user_doesnt_exist
    
  def user_already_exists
  end # user_already_exists
  
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
