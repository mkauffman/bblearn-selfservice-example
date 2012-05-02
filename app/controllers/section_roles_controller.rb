require 'csv'

class SectionRolesController < ApplicationController
  def index
    @section_roles  = SectionRole.find(:all,
        :conditions =>
        ['users_pk1 = :users_pk1 and role = :role', 
        {:users_pk1 => session[:obo_pk1], :role => 'ci'}])
    @sections = []    
    @section_roles.each {|sr| @sections << sr.section }
  end

  def comm_index    #find all communities the individual is a leader of
    @section_roles  = SectionRole.find(:all,
        :conditions =>
        ['users_pk1 = :users_pk1 and role = :role', 
        {:users_pk1 => session[:obo_pk1], :role => 'ci'}])
    
    @comm_sections = []    
    @section_roles.each do |sr|
      if(Section.find_by_pk1_and_service_level(sr.crsmain_pk1, 'C'))                   #The course_main table has a service_level field
         @comm_sections << Section.find_by_pk1_and_service_level(sr.crsmain_pk1, 'C')  #which contains 'C' for all communities 
      end
    end
  end

   

  def add
    role          = enrollment_type(params[:enrollment])
    user          = User.find_by_user_id(params[:user_id])
    @section_role = SectionRole.create(params[:id], user.pk1, role)
    redirect_to :action => "edit", :enrollment => params[:enrollment], :id => params[:id]
  end

  def add_multiple
   @mem_id = []   
   CSV.open(params[:member_list], 'r', '\n').each do |row|
     @mem_id << row[0]
   end
  end
   
  def remove
    params[:rm_guest].each do |sr_ids|
      @section_role = SectionRole.find(sr_ids)
      SectionRole.destroy(@section_role)
    end
    redirect_to :action => "edit", :enrollment => params[:enrollment], :id => params[:id]
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
      when 'instructors' 
      enrollment_type = 'ci'
      when 'graders'
      enrollment_type = 'G'
      when 'designers', 'Co-leaders' 
      enrollment_type = 'gi'
      when 'students', 'Participants'
      enrollment_type = 'S'
      when 'members'
      enrollment_type = 'U'
      when 'assistant'
      enrollment_type = 'T'
    end
    return enrollment_type

  end





def filter(*params)
    problem = false
    params = params.flatten
    for param in params
      reg_filter = Regexp.new('[^-_,@\.\s:A-Za-z0-9]')
      if reg_filter.match(param)
        problem = true
      end # if match
    end # for param
    if problem
      redirect_to(:controller => "selfservice", :action => "problem") and return
    else
      return true
    end # if problem
  end # filter


end

