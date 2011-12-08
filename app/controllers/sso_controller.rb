require 'logger'

class SsoController < ApplicationController
  include Sso_connections

  def index
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


#TODO move much of this code into a model.
  def login
    section = Section.find_by_course_id(params[:section])
    if section.nil?
      url = nil
    elsif params[:mode] == "admin"
      url = admin_signon
    elsif params[:mode] == "designer"
      url = designer_signon(section)
    elsif params[:mode] == "student"
      url = student_signon(section)
    end
    unless section.nil?
      logger.info 'User: '+session[:user]+' is using the SSO tool on behalf of '
      logger.info params[:sso_id]+' for course: '+params[:section]
    end
    if url.nil?
      render :action => "invalid_options"
    else
      redirect_to(url)
    end
  end

end

