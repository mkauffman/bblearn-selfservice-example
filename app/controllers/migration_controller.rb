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


  def add

    @migration  = Migration.build
    @section    = Section.find()
    @user       = User.find()

    @migration.save!

    redirect_to :action => 'index'

  end

private

  def add_migration_value
    @migration.datestamp            = Time.now.strftime("%Y%m%d%H%M%S")
    @migration.sourceid             = @section.course_id
    @migration.status               = 'pending'
    @migration.lastname             = @user.last_name
    @migration.firstname            = @user.first_name
    @migration.email                = @user.email
    @migration.section_description  = @section.short_name 
  end

end
