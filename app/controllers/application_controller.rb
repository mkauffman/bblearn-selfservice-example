require 'rubygems'

class ApplicationController < ActionController::Base
  include CasLogin

  before_filter :authentication
  before_filter :session_expiry
  before_filter :update_activity_time
  #before_filter :get_ws_token
  helper        :all
  before_filter :authorization

  protect_from_forgery
  
  def authentication
    unless session_exists
      if logged_in
        set_session
      end
    end
  end

  def logged_in
    if is_authenticated?
      @user = get_authenticated_user_id
      return true
    else
      return false
    end
  end
  
  
  #################### AUTHORIZATION ##################
    
  def authorization
    if controller_name == "static"
      return true
    end
    if controller_name == "sessions" && action_name == "logout"
      return true
    end
    unless session[:user_object].allowed?(controller_name,action_name)
      redirect_to :controller => 'static', :action => 'not_allowed'
    end
  end

  
  #################### SESSION ##################

  def session_exists
    if session[:user].nil?
      return false
    else
      return true
    end
  end

  def end_session
    session[:user_object]   = nil
    session[:user]          = nil
    session[:users_pk1]     = nil
    session[:on_behalf_of]  = nil
    session[:obo_pk1]       = nil
    session[:expires_at]    = nil
    redirect_to "https://cas.csuchico.edu/cas/logout?service=bblearn"
  end

  def set_session
    session_user            = User.find_by_user_id(@user)
    session[:user_roles]    = session_user.all_roles
    session[:user_object]   = session_user
    session[:user]          = session_user.user_id
    session[:users_pk1]     = session_user.pk1
    session[:on_behalf_of]  = session_user.user_id
    session[:obo_pk1]       = session_user.pk1
  end

  def session_expiry
    if session[:expires_at].blank?
      session[:expires_at] = 15.minutes.from_now
    else
      time_left = (session[:expires_at] - Time.now).to_i
      unless time_left > 0
        end_session        
      end
    end
  end
  
  def update_activity_time
    session[:expires_at] = 15.minutes.from_now
  end


  #################### WEB SERVICES ####################

  def get_ws_token
    if session[:token].nil?
      con             = ContextWS.new
      session[:token] = con.ws
    end
  end


end

