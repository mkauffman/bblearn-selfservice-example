MAIN_HTML   = 'learn_contnt_html'
TASKS_CSS   = 'learn_tasks_html'
MAIN_CSS    = 'learn_main_css'
FERPA_TEXT  = 'learn_ferpa_text'

class TlpAdminController < ApplicationController

  def index    
    @main_html  = Tlp.find_by_html_type(MAIN_HTML)
    @task_css   = Tlp.find_by_html_type(TASKS_CSS)
    @main_css   = Tlp.find_by_html_type(MAIN_CSS)
    @ferpa_text = Tlp.find_by_html_type(FERPA_TEXT)    
  end 
  
  def main_html    
    logger.info 'Changing main page html, user: '+session[:user]
    old_html = Tlp.find_by_html_type(MAIN_HTML)
    unless old_html.nil?
      old_html.update_attributes(:html => params[:tlp_html])
    else
      Tlp.create(:html => (params[:tlp_html].strip), :html_type => MAIN_HTML)
    end
      redirect_to(:action => "index") and return        
  end 
  
  def task_css    
    logger.info 'Changing task bar css, user: '+session[:user]
    old_css = Tlp.find_by_html_type(TASKS_CSS)
    unless old_css.nil?
      old_css.update_attributes(:html => params[:tlp_css])
    else
      Tlp.create(:html => (params[:tlp_css].strip), :html_type => TASKS_CSS)
    end 
    redirect_to(:action => "index") and return        
  end
  
  def main_css
    logger.info 'Changing main page css, user: '+session[:user]
    old_css = Tlp.find_by_html_type(MAIN_CSS)
    unless old_css.nil?
      old_css.update_attributes(:html => params[:tlp_css])
    else
      Tlp.create(:html => (params[:tlp_css].strip), :html_type => MAIN_CSS)
    end 
    redirect_to(:action => "index") and return   
  end
  
  def ferpa
    logger.info 'Changing designer ferpa message, user: '+session[:user]
    old_css = Tlp.find_by_html_type(FERPA_TEXT)  
    unless old_css.nil?
      old_css.update_attributes(:html => params[:ferpa_text].strip)
    else
      Tlp.create(:html => params[:ferpa_text].strip, :html_type => FERPA_HTML)
    end 
    redirect_to(:action => "index") and return 
  end
  
end 
