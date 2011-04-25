# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  before_filter :is_logged_in  # comment this out if you want to skip login
  before_filter :update_activity_time
  before_filter :vista_db_setup
  after_filter :vista_db_teardown
  include CasLogin
  begin
    #include XmlClient
  rescue
    logger.info 'Xml_client library failed to load.'
  end
  require 'oci8'
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  def is_logged_in
    return true unless session[:user].nil? # if we're already logged in, then we won't again.
    if is_authenticated?
      begin # Can hack in a fake user and role here.
        #@user = "mcarlson_instructor" # @user =  get_authenticated_user_id # << this is the code...
        @user =  get_authenticated_user_id
        begin
          @role = Role.find(:first, :conditions => "portal_id = '#{@user}'") # @role is a string, we need symbol
        rescue
          redirect_to(:controller=>"selfservice", :action=>"db_down")
        end
        session[:user] = @user
        session[:on_behalf_of] = @user
        if @user == 'mkauffman'
          session[:role] = "super".to_sym
        else
          if !(@role.nil?)
            session[:role] = (@role.attributes["role"]).to_sym
          else
            session[:role] = :none
          end # if role not nil
        end # if user mkauffman
        return true
      end 
    end # if is_authenticated?
    return false
  end # def is_logged_in
  
  def session_expiry
    reset_session
    session[:user] = nil
    redirect_to "https://cas.csuchico.edu/cas/logout?service=%2Fvista%2Fselfservice"
  end # session_expiry
  
  def update_activity_time
    from_now = 15.minutes.from_now
    if session[:expires_at].blank?
      session[:expires_at] = from_now
    else
      time_left = (session[:expires_at].utc - Time.now.utc).to_i
      unless time_left > 0
        session_expiry
      else
        session[:expires_at] = from_now
      end # unless time_left
    end # if session[:expires_at]
  end # update_activity_time
  
  def is_authorized(required_roles) #required_roles is an array of roles that are allowed through.
    unauthorized_path = url_for(:controller => "application", :action => "unauthorized")
    temp = required_roles.index(session[:role]) 
    if (temp != nil )
      return true
    else
      redirect_to unauthorized_path and return false
    end # if (required_role == sesion[:role] )
  end # def is_authorized
  
  def vista_db_setup
    $vista_db_conn = OCI8.new(AppConfig.vista_db_user, AppConfig.vista_db_password, AppConfig.vista_db_string)
  end # vista_db_setup
  
  def vista_db_teardown
    $vista_db_conn.logoff
  end
  
  def unauthorized
  end
  
  def logout
    reset_session
    redirect_to "https://cas.csuchico.edu/cas/logout?service=%2Fvista%2Fselfservice"
  end
end # class ApplicationController

