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
    host      = "lms-temp.csuchico.edu"
    block     = "/webapps/bbgs-autosignon-BBLEARN2/autoSignon.do"
    courseId  = Section.find_by_course_id(params[:section]).batch_uid
    timestamp = Time.now.to_i.to_s
    userId    = User.find_by_user_id(params[:sso_id]).batch_uid
    secret    = "3B1!ndM!ce..."

    #TEST DATA:
    #timestamp = '1313707563'
    #userId = "@tmsomma"
    #courseId = "tms_sandbox_01"
    
    auth = Digest::MD5.hexdigest(courseId+timestamp+userId+secret)
    
    # Login to Blackboard Learn:
    url = "https://"+host+block
    url += "?courseId="+courseId
    url += "&timestamp="+timestamp
    url += "&userId="+userId
    url += "&auth="+auth

    #logger.info 'User: '+session[:user]+' is using the SSO tool on behalf of '+params[:sso_id]+' for course: '+params[:section]
    redirect_to(url)   
  end
    
end
