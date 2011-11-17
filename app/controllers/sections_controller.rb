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
      Section.destroy(params[:sections])
      redirect_to :action => 'index'
    end
    
    def remove_prep
      Section.destroy(params[:sections])
      redirect_to :action => 'prep_index'
    end

    def available
      section = Section.find(params[:section_id])
      Section.update(section)
      redirect_to :action => 'index'
    end
    
    def enable_disable
      section = Section.find(params[:section_id])
      if section.row_status == 0
        disable_section(section)
      else
        enable_section(section)
      end
      redirect_to :action => 'enable_index'
    end


private
  
  def find_sections_without_prep
      sections      = Section.find_all_for_instructor_pk1(session[:obo_pk1])
      prep_sections = Section.find_all_prepareas_for_instructor_pk1(session[:obo_pk1])
      @sections     = sections - prep_sections
  end

end


