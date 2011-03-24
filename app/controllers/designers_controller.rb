class DesignersController < ApplicationController
  def index
    @sections = Section.find_sections_by_primary_instructor_id(session[:on_behalf_of])
  end # index
  
  def form
    if empty_param(params[:source_id])
      if filter(params[:source_id])
        if check_permissions(params[:source_id])
          @section = Section.find_section_by_section_id(params[:source_id]).last
          @designers = Person.find_guest_designers_by_section_obj(@section)
          begin
            @ferpa_text = Tlp.find(:first, :conditions => "html_type = 'ferpa_text'").html
          rescue
          end
        end # if check_permissions
      end # if filter
    end # if nil_param
  end # form
  
  def add
    # redirect to the section list if the params are nil
    if submit_check(params[:commit])
      if empty_param(params[:source_id], params[:portal_id])
        if filter(params[:source_id], params[:portal_id])
          if check_permissions(params[:source_id])
            if check_user(params[:portal_id])
              unless Person.check_if_user_is_student_in_section(params[:source_id], params[:portal_id])
                if check_enrolled(params[:portal_id], params[:source_id])
                  logger.info "Add a designer, user: "+session[:user]+", section: "+params[:source_id]+", designer: "+params[:portal_id]
                  @section = Section.find_section_by_section_id(params[:source_id]).last
                  designer = Person.find_person_by_webct_id(params[:portal_id]).last
                  xml = Xml_strings.open_xml(@section)
                  xml += designer.add_designer(@section)
                  if params[:instructor_check_box] == "add_instructor"
                    xml += designer.add_guest_instructor(@section)
                  end # if inst
                  xml += Xml_strings.close_xml
                  
                  @res = Xml_client.post(xml).body.content
                  @designers = Person.find_guest_designers_by_section_obj(@section)
                  begin
                    @ferpa_text = Tlp.find(:first, :conditions => "html_type = 'ferpa_text'").html
                  rescue
                  end # error check if ferpa_text nil
                end # if check_enrolled
              else # unless person is student
                redirect_to(:action => "is_student")
              end # unless person is student
            end # if check_user
          end # if check_permissions
        end # if filter
      end # empty param check
    end # if submit_check
  end # add
  
  def remove
    if submit_check(params[:commit])
      if empty_param(params[:source_id], params[:rm_guest])
        if filter(params[:source_id], params[:rm_guest])
          if check_permissions(params[:source_id])
            if check_user(params[:rm_guest])
              designers_logger = ""
              params[:rm_guest].each do |d|
                designers_logger += d.strip+", "
              end # params[:rm_guest]
              logger.info "Remove designer(s), user: "+session[:user]+", section: "+params[:source_id]+", designers: "+designers_logger
              
              @section = Section.find_section_by_section_id(params[:source_id]).last
              xml = Xml_strings.open_xml(@section)
              for des in params[:rm_guest]
                designer = Person.find_person_by_webct_id(des.strip).last
                xml += designer.remove_designer(@section)
                xml += designer.remove_instructor(@section)
              end # for designer
              xml += Xml_strings.close_xml
              
              @res = Xml_client.post(xml).body.content
              @designers = Person.find_guest_designers_by_section_obj(@section)
              begin
                @ferpa_text = Tlp.find(:first, :conditions => "html_type = 'ferpa_text'").html
              rescue
              end
            end # if check_user
          end # if check_permissions
        end # if filter
      end # if empty_param
    end # if submit_check
  end # remove
  
  def is_student
  end # is_student
  
  
  
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
  
  def check_enrolled(webct_id, section_id)
    if Person.check_if_user_is_in_section(section_id, webct_id)
      redirect_to(:controller => "selfservice", :action => "already_enrolled") and return
    else
      return true
    end # if designer
  end # check_enrolled
  
  def check_user(*ids)
    problem = false
    for webct_id in ids
      if webct_id.kind_of?(Array)
        for id in webct_id
          unless Person.check_user_id_existence(id)
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
  
  def submit_check(commit)
    unless (commit=="Add") or (commit=="Remove")
      redirect_to(:action => "index") and return
    else
      return true
    end # unless commit
  end # submit_chk
  
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
end # Designers
