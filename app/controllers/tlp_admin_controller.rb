class TlpAdminController < ApplicationController
  before_filter do |c|
    c.send(:is_authorized, [:super, :admin, :tlp_admin])
  end
  require "cgi"
  
  def index
    if (chk_db)
      @main_html = Tlp.find(:first, :conditions => "html_type = 'contnt_html'")
      @task_css = Tlp.find(:first, :conditions => "html_type = 'tasks_css'")
      @main_css = Tlp.find(:first, :conditions => "html_type = 'main_css'")
      @ferpa_text = Tlp.find(:first, :conditions => "html_type = 'ferpa_text'")
    end # if chk_db
  end # index
  
  def main_html
    if (submit_chk)
      if (chk_db)
        logger.info 'Changing main page html, user: '+session[:user]
        old_html = Tlp.find(:first, :conditions => "html_type = 'contnt_html'")
        unless old_html.nil?
          old_html.update_attributes(:html => params[:tlp_html])
        else
          Tlp.create(:html => (params[:tlp_html].strip), :html_type => "contnt_html")
        end
        redirect_to(:action => "index") and return
      end # if chk_db
    end # if submit_chk
  end # edit_html
  
  def task_css
    if (submit_chk)
      if (chk_db)
        logger.info 'Changing task bar css, user: '+session[:user]
        old_css = Tlp.find(:first, :conditions => "html_type = 'tasks_css'")
        unless (old_css.nil?)
          old_css.update_attributes(:html => params[:tlp_css])
        else
          Tlp.create(:html => (params[:tlp_css].strip), :html_type => "tasks_css")
        end # unless old_css
        redirect_to(:action => "index") and return
      end # if chk_db
    end # if submit_chk
  end # edit_css
  
  def main_css
    if (submit_chk)
      if (chk_db)
        logger.info 'Changing main page css, user: '+session[:user]
        old_css = Tlp.find(:first, :conditions => "html_type = 'main_css'")
        unless (old_css.nil?)
          old_css.update_attributes(:html => params[:tlp_css])
        else
          Tlp.create(:html => (params[:tlp_css].strip), :html_type => "main_css")
        end # unless old_css
        redirect_to(:action => "index") and return
      end # if chk_db
    end # if submit_chk
  end # edit_css
  
  def ferpa
    if (submit_chk)
      if (chk_db)
        logger.info 'Changing designer ferpa message, user: '+session[:user]
        old_css = Tlp.find(:first, :conditions => "html_type = 'ferpa_text'")
        ferpa_text = params[:ferpa_text].strip
        if ferpa_text.empty?: ferpa_text = nil end
        unless (old_css.nil?)
          old_css.update_attributes(:html => ferpa_text)
        else
          Tlp.create(:html => ferpa_text, :html_type => "ferpa_text")
        end # unless old_css
        redirect_to(:action => "index") and return
      end # if chk_db
    end # if submit_chk
  end # ferpa
  
  
  ################################### Private Functions ####################################
  private
  def chk_db
    begin
      Tlp.find(:first, :conditions => "html_type = 'contnt_html'")
    rescue
      redirect_to(:controller => "selfservice", :action => "db_down") and return
    end
    return true
  end # chk_db
  
  def submit_chk
    if (params[:commit]=="Submit")
      return true
    else
      redirect_to(:controller=>"selfservice", :action=>"index") and return
    end # if params commit
  end # submit_chk
end # class tlpAdminController
