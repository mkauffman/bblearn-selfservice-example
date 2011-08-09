
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

  def edit
    role      = enrollment_type(params[:enrollment])
    @section  = Section.find(params[:id])
    @users    = User.find_by_section_and_role(params[:id],role)
  end

private

  def enrollment_type(role)

    case role
      when 'designers'
      enrollment_type = 'gi'
      when 'students'
      enrollment_type = 'S'
      when 'members'
      enrollment_type = 'members'
    end
    return enrollment_type

  end

end

