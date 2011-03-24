class MembersController < ApplicationController
  def index
    # List of sections available for management to the current user
    @sections = Section.find_sections_by_primary_instructor_id_and_term_id(session[:on_behalf_of], "group-term")
  end # index
  
  def form
    if empty_param(params[:source_id])
      if filter(params[:source_id])
        if check_permissions(params[:source_id])
          # get community members of selected section
          @members = Person.find_students(params[:source_id])
          @section = Section.find_section_by_section_id(params[:source_id]).last
        end # if check_permissions
      end # if filter
    end # params nil?
  end # form
  
  def remove
    if submit_check(params[:commit])
      if empty_param(params[:source_id], params[:rm_member])
        if filter(params[:source_id], params[:rm_member])
          if check_permissions(params[:source_id])
            if check_user(params[:rm_member])
              logger_mems = ""              
              for m in params[:rm_member]: logger_mems += m.strip+", " end
              logger.info "Remove members, user: "+session[:user]+" section: "+params[:source_id]+" members: "+logger_mems
              @section = Section.find_section_by_section_id(params[:source_id]).last
              
              xml = Xml_strings.open_xml(@section)
              for mem in params[:rm_member]
                member = Person.find_person_by_webct_id(mem.strip).last
                xml += member.remove_student(@section)
              end # for member
              xml += Xml_strings.close_xml
              
              @res = Xml_client.post(xml).body.content
              @members = Person.find_students(params[:source_id])
            end # if check_user
          end # if check_permissions
        end # if filter
      end # if empty_param
    end # if submit_check
  end # remove
  
  def add
    if submit_check(params[:commit])
      # check if params are nil
      if empty_param(params[:source_id])
        if filter(params[:source_id])
          if check_permissions(params[:source_id])
            # check whether there is one or multiple community members being added
            if params[:portal_id].nil?
              # multiple community members, so split the CSVs into an array
              begin
                id_string = params[:member_list].read.to_s
              rescue
                redirect_to :action => "index" and return
              end
              unless too_large(id_string)
                id_array = id_string.split(/,/)
                if filter(id_array)
                  checked_users = check_user(id_array)
                  unless checked_users.empty?
                    # Add the current user to the community, store the response
                    logger.info "Add members, User: "+session[:user]+", Section: "+params[:source_id]+", Members: "+id_string
                    @section = Section.find_section_by_section_id(params[:source_id]).last
                    
                    xml = Xml_strings.open_xml(@section)
                    for id in checked_users
                      member = Person.find_person_by_webct_id(id.strip).last
                      xml += member.add_student(@section)
                    end # for id
                    xml += Xml_strings.close_xml
                    
                    @res = Xml_client.post(xml).body.content
                    @members = Person.find_students(params[:source_id])
                  end # unless checked_users
                  problem_array
                end # if filter
              end # unless too_large
            else # portal_id param not nil (single name being added)
              if filter(params[:portal_id])
                checked_users = check_user(params[:portal_id])
                unless checked_users.empty?
                  # Add community member and store response
                  logger.info "Add member, User: "+session[:user]+", Section: "+params[:source_id]+", Member: "+params[:portal_id]
                  
                  @section = Section.find_section_by_section_id(params[:source_id]).last
                  member = Person.find_person_by_webct_id(checked_users.first).last
                  xml = Xml_strings.open_xml(@section)
                  xml += member.add_student(@section)
                  xml += Xml_strings.close_xml
                  
                  @res = Xml_client.post(xml).body.content
                  @members = Person.find_students(params[:source_id])
                end # unless checked_users
                problem_array
              end # if filter
            end # if portal_id param nil (multi_portal_ids not nil)
          end # if check_permissions
        end # if filter
      end # if empty_param
    end # if submit_check
  end # add
  
  def id_problem
  end # id_problem
  
  
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
  
  def too_large(ids)
    if ids.length > 1000
      redirect_to :action => "too_large" and return true
    else
      return false
    end # if length
  end # too_large
  
  def check_user(*ids)
    @problem = false
    checked_people = Array.new
    for webct_id in ids
      if webct_id.kind_of?(Array)
        for id in webct_id
          id = id.strip
          unless checked_people.include?(id)
            unless Person.check_user_id_existence(id.strip)
              if @problem.is_a?(Array): @problem << id else @problem = [id] end
            else
              checked_people << id
            end # if check
          end # unless checked_people
        end # for id
      else
        webct_id = webct_id.strip
        unless checked_people.include?(webct_id)
          unless Person.check_user_id_existence(webct_id)
            if @problem.is_a?(Array): @problem << webct_id else @problem = [webct_id] end
          else
            checked_people << webct_id
          end # if check
        end # unless checked_people
      end # if webct_id kind of
    end # for webct_id
    return checked_people
  end # chk_user
  
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
  
  def chk_response(response)
    if response.nil?
      redirect_to(:controller => "selfservice", :action => "http_problem") and return
    else
      return true
    end # if response section
  end # chk_response
  
  def submit_check(commit)
    unless (commit=="Add") or (commit=="Remove")
      redirect_to(:action => "index") and return
    else
      return true
    end # unless commit
  end # submit_chk
  
  def problem_array
    if @problem.is_a?(Array)
      redirect_to(:action => "id_problem", :portal_ids => @problem) and return
    else
      return true
    end # if @problem
  end # @problem array
end # MembersController
