class CourseRoleController < ApplicationController

  def index
    @sections = Section.find_by_user(params[:current_user])
  end

  def new
    @course_role = Role.new(params[:section_id], params[:user_id])
  end


  def destroy
    @course_role = Role.find(params[:role_id])
    @course_role = Role.destroy
  end

  def edit_designers
    @designers = User.find_by_section_and_role(params[:section], 'designer')
  end

  def edit_students
    @students = User.find_by_section_and_role(params[:section], 'students')
  end

  def edit_members
    @members = User.find_by_section_and_role(params[:section], 'members')
  end

end

