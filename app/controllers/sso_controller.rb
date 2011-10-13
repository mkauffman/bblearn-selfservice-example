require 'logger'

class SsoController < ApplicationController
  include Sso_connections

  #before_filter :check_permission

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
    section = Section.find_by_course_name(params[:section])
    if section.nil?
      redirect_to(:controller => "selfservice", :action => "section_id_failure")
    end
    if params[:mode] == "admin"
      url = admin_signon
    elsif params[:mode] == "designer"
      url = designer_signon(section)
    elsif params[:mode] == "student"
      url = student_signon(section)
    end
    logger.info 'User: '+session[:user]+' is using the SSO tool on behalf of '+params[:sso_id]+' for course: '+params[:section]
    redirect_to(url)
  end

end

