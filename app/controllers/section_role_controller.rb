class SectionRoleController < ApplicationController
  def index
    @section_roles = SectionRole.find(:all,
        :conditions =>
        ['users_pk1 = :users_pk1 and role = :role', {:users_pk1 => session[:users_pk1], :role => 'P'}])
  end

  def add
    role          = enrollment_type(params[:enrollment])
    user          = User.find_by_user_id(params[:user_id])
    @section_role = SectionRole.create(params[:id], user.pk1, role)
  end


  def destroy
    @section_role = SectionRole.find(params[:rm_guest])
    CourseRole.destroy(@section_role)
  end

  def edit
    role              = enrollment_type(params[:enrollment])
    @section          = Section.find(params[:id])
    @section_roles    = SectionRole.find(:all,
        :conditions =>
        ['crsmain_pk1 = :id and role = :role', {:id => params[:id], :role => role}])
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

