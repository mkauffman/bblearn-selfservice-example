class MigrationController < ApplicationController
  def index
    @sections = Section.find_sections_by_primary_instructor_id(session[:on_behalf_of])
    terms = Term.find_sso_terms
    @option_string = "<option></option>"
    for term in terms
      @option_string += "<option>"+term.description+"</option>"
    end # for term
  end # index

  def form
  end # form

end # Migration Controller
