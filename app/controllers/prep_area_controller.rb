class PrepAreaController < ApplicationController
  def index
    # This is a selection screen of all the sections
    if chk_ctrl_permission
      @sections = Section.find_sections_by_primary_instructor_id_and_term_id(session[:on_behalf_of], "preparea-term")
    end # if chk_ctrl_permission
  end # index
  
  def create
    if submit_check(params[:commit])
      if empty_param(params[:source_id])
        if chk_ctrl_permission
          # check user permission to create prep course
          if filter(params[:source_id])
            logger.info 'Create prep area, user: '+session[:user]+', on behalf of: '+session[:on_behalf_of]+', prep area: '+params[:source_id]
            person = Person.find_person_by_webct_id(session[:on_behalf_of]).last
            
            section = Section.new
            section.datasource = "CSU Chico - CMS"
            section.source = "CSU Chico - CMS"
            section.section_id = session[:on_behalf_of]+"-selfservice-devcourse"
            section.short_name = "Prep Area "+session[:on_behalf_of]+"-selfservice"
            section.long_name = session[:on_behalf_of]+" Prep Area selfservice"
            section.full_name = ""
            section.term_id = "preparea-term"
            section.term_datasource = "CSU Chico - CMS"
            section.admin_period = "preparea-term"
            section.accept_enrollment = "1"
            section.parent_source = "CSU Chico - CMS"
            section.parent_id = "under_dev_selfservice"
            
            
            xml = Xml_strings.open_xml(section)
            xml += section.create_course
            
            section.section_id = session[:on_behalf_of]+"-"+params[:source_id]
            section.short_name = params[:source_id]
            section.long_name = params[:source_id]
            section.full_name = params[:source_id]
            section.parent_id = session[:on_behalf_of]+"-selfservice-devcourse"
            
            xml += section.create_section
            xml += person.add_primary_instructor(section)
            xml += person.add_designer(section)
            xml += Xml_strings.close_xml
            
            @res = Xml_client.post(xml).body.content
            @sections = Section.find_sections_by_primary_instructor_id_and_term_id(session[:on_behalf_of], "preparea-term")
          end # check input
        end # chk_ctrl_permission
      end # unless param nil
    end # if submit_chk
  end # create
  
  def confirm
    if chk_ctrl_permission
      if submit_check(params[:commit])
        if empty_param(params[:rm_prep])
          if filter(params[:rm_prep]): end 
        end #if params empty
      end # if submit_chk
    end # if chk_ctrl_permission
  end # confirm
  
  def delete
    if chk_ctrl_permission
      if submit_check(params[:commit])
        if empty_param(params[:source_ids])
          if param_del(params[:del_confirm_field])
            if filter(params[:source_ids])
              logger.info 'Delete prep area, user: '+session[:user]+', on behalf of '+session[:on_behalf_of]+', prep area: '+params[:source_ids].to_s
              # check permission to selected section
              sect = Section.find_section_by_section_id(params[:source_ids].last).last
              xml = Xml_strings.open_xml(sect)
              for section_id in params[:source_ids]
                if check_permissions(section_id)
                  section = Section.find_section_by_section_id(section_id).last
                  xml += section.delete_section
                end # check permission
              end # for each source id params
              xml += Xml_strings.close_xml
              @res = Xml_client.post(xml).body.content
              @sections = Section.find_sections_by_primary_instructor_id_and_term_id(session[:on_behalf_of], "preparea-term")
            end # if filter
          end # user typed delete?
        end # if params nil
      end # if submit_chk
    end # if chk_ctrl_permission
  end # delete
  
  
  
  ################################### Private Functions ####################################
  private
  def chk_ctrl_permission
    unless Section.find_sections_by_primary_instructor_id(session[:on_behalf_of]).empty?
      return true
    else
      redirect_to :controller => "selfservice", :action => "permission"
    end # unless Section
  end # chk_ctrl_permissions
  
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
  
  def check_user(*ids)
    problem = false
    for webct_id in ids
      if webct_id.kind_of?(Array)
        for id in webct_id
          unless Person.check_user_id_existence(id.strip)
            problem = true
          end # if check
        end # for id
      else
        unless Person.check_user_id_existence(webct_id)
          problem = true
        end # if check
      end # if webct_id kind of
    end # for webct_id
    if problem
      redirect_to(:controller => "selfservice", :action => "portal_id_failure") and return
    else
      return true
    end # if problem
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
  
  def submit_check(commit)
    unless commit=="Add" or commit=="Remove" or commit=="Create" or commit=="Delete" or commit=="Confirm"
      redirect_to(:action => "index") and return
    else
      return true
    end # unless commit
  end # submit_chk
  
  def param_del(param)
    unless (param=="delete")
      redirect_to(:action=>"index")
    else
      return true
    end # unless param
  end # param_del
end # PrepAreaController
