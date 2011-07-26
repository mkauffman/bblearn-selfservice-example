class CourseRoleController < ApplicationController

  def index
    @sections = Section.find_by_user(session[:user])
  end

  def new
    @course_role = Role.new(params[:section_id], params[:user_id], params[:role_id])
  end


  def destroy
    @course_role = Role.find(params[:user_id], params[:course_id])
    @course_role = Role.destroy
  end

  def edit_designers
    @designers = User.find_by_section_and_role(params[:section], 'gi')
  end

  def edit_students
    @students = User.find_by_section_and_role(params[:section], 'S')
  end

  def edit_members
    @members = User.find_by_section_and_role(params[:section], 'members')
  end

end

