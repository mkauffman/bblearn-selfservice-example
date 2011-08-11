class SectionController < ApplicationController

	def index
			@section_roles = SectionRole.find(:all,
			:conditions =>
			['users_pk1 = :users_pk1 and role = :role', {:users_pk1 => session[:users_pk1], :role => 'P'}])
	end


end

