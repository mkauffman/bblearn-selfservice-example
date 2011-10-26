require "cgi"

class TlpAdminController < ApplicationController
  include CasLogin  
  
  def index    
    @main_html  = Tlp.find(:first, :conditions => "html_type = 'migrate_contnt_html'")
    @task_css   = Tlp.find(:first, :conditions => "html_type = 'migrate_tasks_css'")
    @main_css   = Tlp.find(:first, :conditions => "html_type = 'migrate_main_css'")
    @ferpa_text = Tlp.find(:first, :conditions => "html_type = 'migrate_ferpa_text'")      
  end 
  
  def main_html    
    logger.info 'Changing main page html, user: '+session[:user]
    old_html = Tlp.find(:first, :conditions => "html_type = 'migrate_contnt_html'")
    unless old_html.nil?
      old_html.update_attributes(:html => params[:tlp_html])
    else
      Tlp.create(:html => (params[:tlp_html].strip), :html_type => "migrate_contnt_html")
    end
      redirect_to(:action => "index") and return        
  end 
  
  def task_css    
    logger.info 'Changing task bar css, user: '+session[:user]
    old_css = Tlp.find(:first, :conditions => "html_type = 'migrate_tasks_css'")
    unless old_css.nil?
      old_css.update_attributes(:html => params[:tlp_css])
    else
      Tlp.create(:html => (params[:tlp_css].strip), :html_type => "migrate_tasks_css")
    end 
    redirect_to(:action => "index") and return        
  end
  
  def main_css
    logger.info 'Changing main page css, user: '+session[:user]
    old_css = Tlp.find(:first, :conditions => "html_type = 'migrate_main_css'")
    unless (old_css.nil?)
      old_css.update_attributes(:html => params[:tlp_css])
    else
      Tlp.create(:html => (params[:tlp_css].strip), :html_type => "migrate_main_css")
    end 
    redirect_to(:action => "index") and return   
  end
  
  def ferpa
    logger.info 'Changing designer ferpa message, user: '+session[:user]
    old_css = Tlp.find(:first, :conditions => "html_type = 'migrate_ferpa_text'")
    ferpa_text = params[:ferpa_text].strip
    if ferpa_text.empty?: ferpa_text = nil end
    unless (old_css.nil?)
      old_css.update_attributes(:html => ferpa_text)
    else
      Tlp.create(:html => ferpa_text, :html_type => "migrate_ferpa_text")
    end 
    redirect_to(:action => "index") and return 
  end
  
end 
