require 'logger'

class SsoController < ApplicationController
  before_filter :check_permission
  
  def index
  end

  def check_permission
    if roles_comp :sso, session[:role]
      return true
    else
      redirect_to :controller => "application", :action => "not_allowed" and return false
    end
  end
  
  def sections
    if User.find_by_user_id(params[:sso_id])
      sso = User.find_by_user_id(params[:sso_id])
      @sections = SectionRole.find_by_id_comparison(sso.pk1, session[:users_pk1])
      if @sections.empty?
        redirect_to(:controller => "application", :action => "no_valid_sections")
      end
    else
      redirect_to(:controller => "application", :action => "portal_id_failure")
    end
  end
  
  def login
    # MAC must be in the following order: courseId, timestamp, userId, secret
    courseId  = Section.find_by_course_id(params[:section]).course_id
    timestamp = Time.now.to_i.to_s
    userId    = User.find_by_user_id(params[:sso_id]).batch_uid
    secret    = "3B1!ndM!ce..."

    auth = Digest::MD5.hexdigest(courseId+timestamp+userId+secret)
    logger.info 'User: '+session[:user]+' is using the SSO tool on behalf of '+params[:sso_id]+' for course: '+params[:section]
    
    # Login to Blackboard Learn:
    #url = "http://lms-temp.csuchico.edu/webapps/bbgs-autosignon-BBLEARN/autoSignon.do"
    url = "http://lms-temp.csuchico.edu/webapps/bbgs-autosignon-bb_bb60/autoSignon.do"
    url += "?courseId="+courseId
    url += "?timestamp="+timestamp
    url += "&userId="+userId
    url += "&auth="+auth
    redirect_to(url)   
  end
    
end
