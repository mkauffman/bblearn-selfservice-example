class SectionRoleController < ApplicationController

  def index
    @sections = Section.find_by_user(session[:user])
  end

  def new
    @section_role = Role.new(params[:section_id], params[:user_id], params[:role_id])
  end


  def destroy
    @section_role = Role.find(params[:user_id], params[:section_id])
    @section_role = Role.destroy
  end

  def edit_designers
    @section   = Section.find(params[:id])
    @designers = User.find_by_section_and_role(params[:id], 'gi')
  end

  def edit_students
    @students = User.find_by_section_and_role(params[:id], 'S')
  end

  def edit_members
    @members = User.find_by_section_and_role(params[:id], 'members')
  end

end

