class VisibilityController < ApplicationController
  def index
    @sections = sections_for_hiding
  end # index
  
  def hide_show
    if empty_param(params[:source_id])
      if filter(params[:source_id])
        if check_permissions(params[:source_id])
          # select returns array, so get last, even though there is only one
          section = Section.find_section_by_section_id(params[:source_id]).last
          if section.term_id == "hidden-term"
            logger.info 'Making section visible, user: '+session[:user]+', section: '+params[:source_id]
            section.term_id = section.admin_period
          else
            logger.info 'Hiding section, user: '+session[:user]+', section: '+params[:source_id]
            section.term_id = "hidden-term"
          end # if section
          xml = Xml_strings.open_xml(section)
          xml += section.update_section
          xml += Xml_strings.close_xml
          @res = Xml_client.post(xml).body.content
          @sections = sections_for_hiding
        end # section permission
      end # user input filter
    end # if params nil
  end # hide_show
  
  
  
  ################################### Private Functions ####################################
  private
  def filter(*params)
    problem = false
    params = params.flatten
    for param in params
      reg_filter = Regexp.new('[^-_,@\s:A-Za-z0-9]')
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
  
  def check_permissions(section)
    db_sect_ary = Section.find_sections_by_primary_instructor_id(session[:on_behalf_of])
    if (db_sect_ary.select{|sect| sect.section_id == section}.empty?)
      redirect_to(:controller => "selfservice", :action => "permission") and return
    else
      return true
    end # if db_sec_ary select
  end # chk_permissions
  
  def empty_param(*params)
    problem = false
    for param in params
      if (param.nil?) or (param.empty?)
        problem = true
      end # if param
    end # for param
    if problem
      redirect_to(:action => "index") and return
    else
      return true
    end # if problem
  end # empty_param
  
  def sections_for_hiding
    terms_array = Term.find_future_terms
    terms_array << Term.find_current_term.last
    sections_array = Array.new
    
    sections = Section.find_sections_by_primary_instructor_id_and_term_id(session[:on_behalf_of], "hidden-term")
    for section in sections
      unless section.nil?: sections_array << section end
    end
    
    for term in terms_array
      sections = Section.find_sections_by_primary_instructor_id_and_term_id(session[:on_behalf_of], term.term_id)
      for section in sections
        unless section.nil?: sections_array << section end
      end # for section
    end # for term
    
    return sections_array
  end # terms_for_hiding
end # VisibilityController
######
