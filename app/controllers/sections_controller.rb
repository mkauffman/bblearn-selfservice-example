class SectionsController < ApplicationController

    def index
      sections      = Section.find_all_for_instructor_pk1(session[:obo_pk1])
      prep_sections = Section.find_all_prepareas_for_instructor_pk1(session[:obo_pk1])
      @sections     = sections - prep_sections
    end

    def prep_index
      @prep_sections = Section.find_all_prepareas_for_instructor_pk1(session[:obo_pk1])
    end

    def add
      section_pk1   = Section.create(params[:course_name])
      @section_role = SectionRole.create(section_pk1, session[:obo_pk1], 'P')
      redirect_to :action => 'index'
    end

    def add_prep
      section_pk1   = Section.create_prep_area(session[:on_behalf_of], params[:course_name])
      @section_role = SectionRole.create(section_pk1, session[:obo_pk1], 'P')
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
      section                 = Section.find(params[:section_id])
      Section.update(section)
      redirect_to :action => 'index'
    end

end


