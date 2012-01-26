class SectionsController < ApplicationController
include SectionEnable
    def index
      find_sections_without_prep
    end

    def enable_index
      find_sections_without_prep
    end

    def prep_index
      @prep_sections = Section.find_all_prepareas_for_instructor_pk1(session[:obo_pk1])
    end

    def add
      section_pk1   = Section.create(params[:course_name])
      @section_role = SectionRole.create(section_pk1, session[:obo_pk1], 'ci')
      redirect_to :action => 'index'
    end

    def add_prep
      section_pk1   = Section.create_prep_area(session[:on_behalf_of], params[:course_name])
      @section_role = SectionRole.create(section_pk1, session[:obo_pk1], 'ci')
      redirect_to :action => 'prep_index'
    end

    def remove
      destroy_sections
      redirect_to :action => 'index'
    end
    
    def remove_prep
      destroy_sections
      redirect_to :action => 'prep_index'
    end
    
#Enable_section and disable_section are called by the
#SectionEnable library. They run a script on the
#server that handles the enabling and disabling
#of both vista and learn sections with the same
#name.

    def enable_disable
      section = Section.find(params[:section_id])
      if section.row_status == 0
        disable_section(section)
      else
        enable_section(section)
      end
      redirect_to :action => 'enable_index'
    end

    def reset_index
      @sections = Section.find_all_for_instructor_pk1(session[:obo_pk1])
    end


#TODO: Move majority of logic to Section model.
    def reset
      @section   = Section.find(params[:section_id])
      @roles     = []
      role       = {}

      @section.section_roles.each do |sr| 
        role[:users_pk1]  = sr.users_pk1
        role[:role]       = sr.role
        @roles << role 
        SectionRole.destroy(sr)
      end

      
      @new_section  = Section.new(@section.attributes)
      @section.destroy
      @new_section.save!

      @new_section = Section.find_by_course_id(@new_section.course_id)

      @roles.each do |role| 

        SectionRole.create(@new_section.pk1, role[:users_pk1], role[:role])
      end
      redirect_to :action => 'reset_index'
    end

private
  
  def find_sections_without_prep
      sections      = Section.find_all_for_instructor_pk1(session[:obo_pk1])
      prep_sections = Section.find_all_prepareas_for_instructor_pk1(session[:obo_pk1])
      @sections     = sections - prep_sections
  end

  def destroy_sections
    params[:sections].each do |pk1|
      section = Section.find(pk1)
      @section_role = SectionRole.find(:all, 
                                       :conditions =>
                                       ['crsmain_pk1 = pk1'])
      SectionRole.destroy(@section_role)  
      section.destroy
  end
  end

end


