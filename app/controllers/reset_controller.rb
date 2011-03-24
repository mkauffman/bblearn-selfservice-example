class ResetController < ApplicationController
  def index
    @list = section_list
  end # index
  
  def confirm
    if empty_param(params[:source_id])
      if filter(params[:source_id])
        if check_permissions(params[:source_id]): end
      end # if filter
    end #if params nil
  end # confirm
  
  def exec
    if submit_check(params[:commit])
      if empty_param(params[:source_id])
        if param_del(params[:del_confirm_field])
          if filter(params[:source_id])
            if check_permissions(params[:source_id])
              logger.info 'Reset section, user: '+session[:user]+', on behalf of: '+session[:on_behalf_of]+', section: '+params[:source_id]
              if /xlist.*/.match(params[:source_id])
                @res = reset_xlist(params[:source_id])
              else
                @res = reset_normal(params[:source_id])
              end # if xlist
              if /Membership import completed successfully/.match(@res)
                redirect_to(:action => "index", :res => "Reset Successful") and return
              else
                redirect_to(:action => "index", :res => @res) and return
              end # if match
            end # if check permissions
          end # filter user input 
        end #if 'delete' was typed
      end #unless params nil
    end #if submit_chk
  end # exec
  
  
  
  
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
    unless commit=="Add" or commit=="Remove" or commit=="Confirm" or commit=="Submit"
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
  
  def param_del(param)
    unless (param=="delete")
      redirect_to(:action=>"index")
    else
      return true
    end # unless param
  end # param_del
  
  def section_list
    semesters = Term.find_future_terms
    semesters << Term.find_irregular_terms
    semesters << Term.find_current_term.last
    semesters = semesters.flatten
    list = Array.new
    for sem in semesters
      list << Section.find_sections_by_primary_instructor_id_and_term_id(session[:on_behalf_of], sem.term_id)
    end # for semesters
    list = list.flatten
    return list
  end # section_list
  
  def reset_normal(section_id)
    section = Section.find_section_by_section_id(section_id).last
    instructors = Person.find_primary_instructor(section_id)
    designers = Person.find_guest_designers_by_section_obj(section)
    teaching_assistants = Person.find_teaching_assistants(section_id)
    auditors = Person.find_auditors(section_id)
    students = Person.find_students(section_id)
    
    xml = Xml_strings.open_xml(section)
    xml += section.delete_section
    xml += section.create_section
    for instructor in instructors
      xml += instructor.add_primary_instructor(section)
      xml += instructor.add_designer(section)
    end # for instructor
    for designer in designers
      instructor_reg = Regexp.new(designer.webct_id)
      unless instructor_reg.match(xml)
        xml += designer.add_designer(section)
      end # unless instructor_reg
    end # for designer
    for teaching_assistant in teaching_assistants
      xml += teaching_assistant.add_teaching_assistant(section)
    end # for ta
    for auditor in auditors
      xml += auditor.add_auditor(section)
    end # for auditor
    for student in students
      xml += student.add_student(section)
    end # for student
    xml += Xml_strings.close_xml
    response = Xml_client.post(xml).body.content
    return response
  end # reset_normal
  
  def reset_xlist(section_id)
    section = Section.find_section_by_section_id(section_id).last
    sections_children = Section.find_xlisted_sections_children_by_section_obj(section)
    instructors = Person.find_primary_instructor(section_id)
    designers = Person.find_guest_designers_by_section_obj(section)
    students = Person.find_students(section_id)
    teaching_assistants = Person.find_teaching_assistants(section_id)
    auditors = Person.find_auditors(section_id)
    master_child = Section.find_section_by_section_id(section.section_id[6, section.section_id.length]).last
    section.template_parent_id = master_child.section_id
    section.template_parent_source = master_child.source
    
    xml = Xml_strings.open_xml(section)
    xml += section.delete_section
    course_description_reg = /[0-9]{3}X-[a-zA-Z]{4}[0-9]{3}[a-zA-Z]?-[0-9]{2}/
    old_description = section.short_name.to_s
    section.short_name = course_description_reg.match(section.short_name).to_s
    section.long_name = course_description_reg.match(section.short_name).to_s
    section.full_name = course_description_reg.match(section.short_name).to_s
    xml += section.create_xlist_course
    section.short_name = old_description
    section.long_name = old_description
    section.full_name = old_description
    xml += section.create_xlist_section
    for sect in sections_children
      sect.parent_id = section.section_id
      xml += sect.add_member_section
    end # for sect
    for instructor in instructors
      xml += instructor.add_primary_instructor(section)
      xml += instructor.add_designer(section)
    end # for instructor
    for designer in designers
      instructor_reg = Regexp.new(designer.webct_id)
      unless instructor_reg.match(xml)
        xml += designer.add_designer(section)
      end # unless instructor_reg
    end # for designer
    for student in students
      xml += student.add_student(section)
    end # for student
    for teaching_assistant in teaching_assistants
      xml += teaching_assistant.add_teaching_assistant(section)
    end # for ta
    for auditor in auditors
      xml += auditor.add_auditor(section)
    end # for auditor
    xml += Xml_strings.close_xml
    response = Xml_client.post(xml).body.content
    return "Reset crosslist complete"
  end # reset_xlist
end # ResetController
