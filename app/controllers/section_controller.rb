require 'logger'

class SectionController < ApplicationController

    def index
      @section_roles = SectionRole.find(:all,
      :conditions => ['users_pk1 = :users_pk1 and role = :role',
      {:users_pk1 => session[:obo_pk1], :role => 'P'}])
    end

    def add
      section_pk1   = Section.create(params[:course_id])
      @section_role = SectionRole.create(section_pk1, session[:users_pk1], 'P')
      redirect_to :action => 'index'
    end

    def add_prep
      section_pk1   = Section.create_prep_area(course_id)
      @section_role = SectionRole.create(section_pk1, session[:users_pk1], 'P')
      redirect_to :action => 'index'
    end

    def remove
      Section.destroy(params[:sections])
      redirect_to :action => 'index'
    end

    def available
      section                 = Section.find(params[:section_id])
      Section.update(section)
      redirect_to :action => 'index'
    end

end

