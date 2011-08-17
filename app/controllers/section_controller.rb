class SectionController < ApplicationController

        def index
	    @section_roles = SectionRole.find(:all,
		:conditions =>
		['users_pk1 = :users_pk1 and role = :role', {:users_pk1 => session[:users_pk1], :role => 'P'}])
	end

        def add
            section_pk1 = Section.create(params[:course_id])
            @section_role = SectionRole.create(section_pk1, session[:users_pk1], 'P')
            redirect_to :action => 'index'
        end

        def remove
            Section.destroy(params[:sections])
            redirect_to :action => 'index'
        end

        def hide
            Section.update(pk1,availability)
        end

end

