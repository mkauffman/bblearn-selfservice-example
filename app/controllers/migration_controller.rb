require 'rubygems'
require 'savon'
require 'gyoku'

class MigrationController < ApplicationController
  include CasLogin
  before_filter :check_permission  
  
  def index
    @sections = Section.find_sections_by_primary_instructor_id_and_term_id(session[:on_behalf_of], "preparea-term")
  end

  def check_permission
    if roles_comp :migration, session[:role]
      return true
    else
      redirect_to :controller => "application", :action => "not_allowed" and return false
    end
  end

  def exec
    if params[:sections].nil?
      flash[:error] = "No section was checked.  Please select a section to migrate first."
      redirect_to :action => "index" and return
    end
    sql = "INSERT INTO bbl_migration (datestamp, sourcedid, instructorid, status, last, first, email, section_description) VALUES "
    sql += "(:timestamp, :sourcedid, :instructorid, :status, :lastname, :firstname, :email, :section_description)"
    cursor = $vista_db_conn.parse(sql)
    for section_id in params[:sections]
      section = Section.find_section_by_section_id(section_id).first
      user = Person.find(session[:on_behalf_of]).first
      cursor.bind_param(':timestamp', Time.now.strftime("%Y%m%d%H%M%S"))
      cursor.bind_param(':sourcedid', section.section_id)
      cursor.bind_param(':instructorid', session[:on_behalf_of])
      cursor.bind_param(':status', "pending")
      cursor.bind_param(':lastname', user.last_name)
      cursor.bind_param(':firstname', user.first_name)
      cursor.bind_param(':email', user.email)
      cursor.bind_param(':section_description', section.short_name)
      response = cursor.exec
      $vista_db_conn.commit
    end
    redirect_to :action => "index" and return
  end

end
