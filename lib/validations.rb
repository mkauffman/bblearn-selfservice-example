module Validations

  def validate_remove(commit, section_id, rm_student)
    return false if !validate_commit(commit)
    return false if !validate_presence(section_id,rm_student)
    return false if !validate_expressions(section_id, rm_student)
    return false if !validate_permissions(section_id)
    return true
  end

  def validate_form(section_id)
    return false if !validate_presence(section_id)
    return false if !validate_expressions(section_id,nil)
    return false if !validate_permissions(section_id)
    return true
  end

  def validate_add(commit, section_id, webct_id)
    return false if !validate_commit(commit)
    return false if !validate_presence(section_id, webct_id)
    return false if !validate_expressions(section_id, webct_id)
    return false if !validate_permissions(section_id)
    return false if !validate_user(webct_id)
    return false if !validate_enrollment(webct_id, section_id)
    return true
  end

  def validate_expressions(string, params)
    filter = '[^-_,@\s:A-Za-z0-9]'
#   filter.sub(reg_exp,'')      may be used for future functionality
    problem = false
    unless params.nil? 
      unless params.kind_of?(Array)
        params = params.split
      end
      params = params.flatten
      for param in params
        reg_filter = Regexp.new(filter)
         if reg_filter.match(param)
          problem = true
        end # if match
       end # for param
    end # unless nil
    reg_filter = Regexp.new(filter)
    if reg_filter.match(string)
      problem = true
    end #if match
    if problem
      redirect_to(:controller => "selfservice", :action => "problem") and return
    else
      return true
    end # if problem
  end


  # filter

  def validate_involvement(webct_id, section_id)
    if Person.check_if_user_is_in_section(section_id, webct_id)
      redirect_to :action => "already_enrolled" and return false
    else
      return true
    end # if designer
  end # check_enrolled


  def validate_enrollment(webct_id, section_id)
    problem = false
    unless webct_id.kind_of?(Array)
      webct_id.split
    end
    webct_id.each do |wid| 
      if Person.check_if_user_is_student_in_section(section_id, wid)
       problem = true
      end
    end
    if problem == true
      redirect_to(:controller => "selfservice", :action => "already_enrolled") and return false
    else
      return true
    end
  end

  def validate_user(*ids)
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
      redirect_to(:controller => "selfservice", :action => "portal_id_failure") and return false
    else
      return true
    end # if problem
  end # chk_user

  def validate_permissions(section)
    db_sect_ary = Section.find_sections_by_primary_instructor_id(session[:on_behalf_of])
    if (db_sect_ary.select{|sect| sect.section_id == section}.empty?)
      redirect_to(:controller => "selfservice", :action => "permission") and return false
    else
      return true
    end # if db_sec_ary select
  end # chk_permissions

  def validate_commit(commit)
    unless (commit=="Add") or (commit=="Remove")
      redirect_to(:action => "index") and return false
    else
      return true
    end # unless commit
  end # submit_chk

  def validate_presence(*params)
    problem = false
    for param in params
      if (param.nil?) or (param.empty?)
        problem = true
      end # if param
    end # for param
    if problem
      redirect_to(:action => "index") and return false
    else
      return true
    end # if problem
  end # empty_param

end
