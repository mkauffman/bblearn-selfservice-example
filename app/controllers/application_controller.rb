require 'oci8'
require 'rubygems'

class ApplicationController < ActionController::Base
  include CasLogin
  include Permissions

  before_filter :vista_db_setup
  before_filter :authentication
  before_filter :set_session_timeout
#  before_filter :get_ws_token
  after_filter  :vista_db_teardown
  helper        :all

  protect_from_forgery

  def index
    @html = Tlp.find(:first, :conditions=>"html_type = 'migrate_contnt_html'").html
  end

  def authentication
    unless session_exists
      if logged_in
        set_session
        retrieve_roles
        set_roles
      end
    end
  end

  def logged_in
    if is_authenticated?
      @user =  get_authenticated_user_id
      return true
    else
      return false
    end
  end

  def logout
    reset_session
    redirect_to "https://cas.csuchico.edu/cas/logout?service=migration"
  end

  #################### SESSION ##################

  def session_exists
    if session[:user].nil?
      return false
    else
      return true
    end
  end

  def set_session
      session[:user]          = @user
      session[:users_pk1]     = User.find_by_user_id(@user).pk1
      session[:on_behalf_of]  = @user
  end

  def end_session
    reset_session
    session[:user] = nil
    redirect_to "https://cas.csuchico.edu/cas/logout?service=migration"
  end

  def set_session_timeout
    from_now = 15.minutes.from_now
    if session[:expires_at].blank?
      session[:expires_at] = from_now
    else
      time_left = (session[:expires_at].utc - Time.now.utc).to_i
      unless time_left > 0
        end_session
      else
        session[:expires_at] = from_now
      end
    end
  end

  #################### ROLE ##################

  def retrieve_roles
    @role     = Array.new
    user      = User.find_by_user_id(session[:user])
    ins_roles = user.all_roles
    ins_roles.each do |r|
      @role   << r.role_id
    end
  end

  def set_roles
    session[:role] = sym_convert(@role)
  end

  #################### PROXY ##################
  def check_proxy_use
    if roles_comp :proxy, session[:role]
      validate_proxy
    else
      redirect_to :controller => "application", :action => "index" and return
    end
  end

  def validate_proxy
    unless User.find_by_user_id(params['act_as'])
       redirect_to :controller => "application", :action => "invalid_user"
    else
       session[:on_behalf_of] = params['act_as']
       redirect_to :controller => "application", :action => "index"
    end
  end

  #################### DATABASE ##################

  def vista_db_setup
    vista_db_user = AppConfig.vista_db_user
    vista_db_password = AppConfig.vista_db_password
    vista_db_string = AppConfig.vista_db_string
    $vista_db_conn = OCI8.new(vista_db_user, vista_db_password, vista_db_string)
    $bbl_db_conn = OCI8.new(AppConfig.bbl_db_user, AppConfig.bbl_db_password, AppConfig.bbl_db_string)
    $bbl_db_table = AppConfig.bbl_db_table
  end

  def vista_db_teardown
    $vista_db_conn.logoff
    $bbl_db_conn.logoff
  end
  #################### WEB SERVICES ####################

  def get_ws_token
    if session[:token].nil?
      con             = ContextWS.new
      session[:token] = con.ws
    end
  end


  #################### ERROR HANDLING ##################

  def unauthorized
  end

  def invalid_user
  end

  def not_allowed
  end

  def db_down
  end

  def problem
  end

  def already_enrolled
  end

  def permission
  end

end # class ApplicationController

