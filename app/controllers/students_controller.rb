class StudentsController < ApplicationController
  def index
    @sections = Section.find_sections_by_primary_instructor_id(session[:on_behalf_of])
  end
  
  def form
    @section = Section.find_section_by_section_id(params[:source_id]).first
    @students = Person.find_students(params[:source_id])
  end
  
  def add
    if submit_check(params[:commit])
      if empty_param(params[:source_id])
        if filter(params[:source_id])
          if check_permissions(params[:source_id])
            if !params[:portal_id].nil?
              if check_user(params[:portal_id])
                if check_enrolled(params[:portal_id], params[:source_id])
                  logger.info "Add a student, user: "+session[:user]+", section: "+params[:source_id]+", student: "+params[:portal_id]
                  @section = Section.find_section_by_section_id(params[:source_id]).last
                  student = Person.find_person_by_webct_id(params[:portal_id]).last
                  
                  xml = Xml_strings.open_xml(@section)
                  xml += student.add_student(@section)
                  xml += Xml_strings.close_xml
                  
                  @res = Xml_client.post(xml).body.content
                  @students = Person.find_students(params[:source_id])
                end # if check_enrolled
              end # if check_user
            elsif !params[:student_list].nil?
              if /\.csv/.match(params[:student_list].original_path)
                @section = Section.find_section_by_section_id(params[:source_id]).last
                student_list = params[:student_list].read.to_s.split(/,/)
                
                students_logger = ""
                xml = Xml_strings.open_xml(@section)
                for student_id in student_list
                  student_id = student_id.to_s.strip
                  student = Person.find_person_by_webct_id(student_id).last
                  if !student.nil?
                    xml += student.add_student(@section)
                  end # if student not nil
                  students_logger << student_id+", "
                end # for list item
                xml += Xml_strings.close_xml
                logger.info "Add a student, user: "+session[:user]+", section: "+params[:source_id]+", student: "+students_logger
                
                @res = Xml_client.post(xml).body.content
                @students = Person.find_students(params[:source_id])
              else
                redirect_to :controller => "selfservice", :action => "csv_error" and return
              end 
            else
              redirect_to :action => "index" and return
            end # if !portal_id nil
          end # if check_permissions
        end # if filter
      end # empty param check
    end # if submit_check
  end # add
  
  def remove
    if submit_check(params[:commit])
      if empty_param(params[:source_id], params[:rm_student])
        if filter(params[:rm_student], params[:source_id])
          if check_permissions(params[:source_id])
            if check_user(params[:rm_student])
              students_logger = ""
              params[:rm_student].each do |s|
                students_logger += s.strip+", "
              end # params[:rm_guest]
              logger.info "Remove designer(s), user: "+session[:user]+", section: "+params[:source_id]+", designers: "+students_logger
              
              @section = Section.find_section_by_section_id(params[:source_id]).last
              xml = Xml_strings.open_xml(@section)
              for stu in params[:rm_student]
                student = Person.find_person_by_webct_id(stu.strip).last
                xml += student.remove_student(@section)
              end # for designer
              xml += Xml_strings.close_xml
              
              @res = Xml_client.post(xml).body.content
              @students = Person.find_students(params[:source_id])
            end # if check_user
          end # if check_permissions
        end # if filter
      end # if empty_param
    end # if submit_check
  end # remove
  
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
      redirect_to :action => "already_enrolled" and return
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
    unless (commit=="Submit") or (commit=="Add") or (commit=="Remove")
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
end # students controller
