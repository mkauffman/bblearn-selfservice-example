class CrosslistController < ApplicationController
  before_filter do |c|
    c.send(:is_authorized, [:super, :admin, :tlp, :tlp_admin])
  end
  
  def index
    # this method should list all the current sections for an instructor
    # Here we are going to get the sections available to be edited by the instructor
    current_term = Term.find_current_term.last
    future_terms = Term.find_future_terms
    
    @sections = Section.find_sections_by_primary_instructor_id_and_term_id(session[:on_behalf_of], current_term.term_id)
    
    @children = Hash.new                                                                          
    for sect in @sections
      if ((/xlist-.*/).match(sect.section_id))
        @children[sect.section_id] = Section.find_xlisted_sections_children_by_section_obj(sect)
      end # if xlist section
    end # for each section
    
    @future_sections = Array.new
    for term in future_terms
      @future_sections << Section.find_sections_by_primary_instructor_id_and_term_id(session[:on_behalf_of], term.term_id)
    end # for each future term
    @future_sections = @future_sections.flatten
    
    @future_children = Hash.new                                                                          
    for sect in @future_sections
      if ((/xlist-.*/).match(sect.section_id))
        @future_children[sect.section_id] = Section.find_xlisted_sections_children_by_section_obj(sect)
      end # if xlist section
    end # for each section
  end # index
  
  def section_mgmt
    # This function redirects based on which button was clicked
    if (filter(params[:commit])) and (filter(params[:sect_id])) and (filter(params[:term_id]))
      if (params[:commit]=="Create")
        redirect_to(:action => "create_list", :sect_id => params[:sect_id], :term_id => params[:term_id]) and return
      elsif (params[:commit]=="Add")
        redirect_to(:action => "add_list", :sect_id => params[:sect_id], :term_id => params[:term_id]) and return
      elsif (params[:commit]=="Remove")
        redirect_to(:action => "rm_list", :sect_id => params[:sect_id], :term_id => params[:term_id]) and return
      elsif (params[:commit]=="Delete")
        redirect_to(:action => "del_confirm", :sect_id => params[:sect_id], :term_id => params[:term_id]) and return
      end # commit is create
    end # filter
  end #section_mgmt
  
  def create_list
    # This will display a list of available sections for cross-listing
    if filter(params[:term_id], params[:sect_id])
      if check_permissions(params[:sect_id])
        if Section.find_section_by_section_id("xlist-"+params[:sect_id]).empty?
          @sections = Section.find_non_xlisted_sections_by_primary_instructor_id_and_term_id(session[:on_behalf_of], params[:term_id])
        else # if db_mgr
          redirect_to(:action => "xlist_exists_already") and return
        end # if db_mgr
      end # if check_permissions
    end # filter
  end # create_list
  
  def create_exec
    if submit_check(params[:commit])
      if empty_param(params[:par_id], params[:sect_id])
        # This will create a xlist with params[:par_id] as the master child and params[:sect_id] as a child
        if filter(params[:par_id], params[:sect_id])
          if check_permissions(params[:par_id], params[:sect_id])
            if Section.find_section_by_section_id("xlist-"+params[:par_id]).empty?
              logger.info 'Create crosslist, user: '+session[:user]+', parent: '+params[:par_id]+', children: '+params[:sect_id].to_s
              xlist = Section.find_section_by_section_id(params[:par_id]).last
              children = Array.new
              children << xlist.clone
              for param in params[:sect_id]
                children << Section.find_section_by_section_id(param)
              end # for param
              children = children.flatten
              
              child_reg = Regexp.new(/[a-zA-Z]{4}[0-9]{3}[A-Z]?-[0-9]{2}/)
              parent_sem_reg = Regexp.new(/[0-9]{3}/)
              parent_id_reg = Regexp.new(/[0-9]{3}-[a-zA-Z]{4}[0-9]{3}[A-Z]?-[0-9]{2}/)
              parent_name = parent_sem_reg.match(params[:par_id]).to_s+"X-"+child_reg.match(params[:par_id]).to_s
              children_name = ""
              iter = 0
              for id in params[:sect_id]
                if (iter < 3)
                  child = child_reg.match(id).to_s
                  children_name << ", "+child
                  iter += 1
                else
                  break
                end # if iter
              end # for id
              xlist.template_parent_id = xlist.section_id
              xlist.template_parent_source = xlist.source
              xlist.section_id = "xlist-"+xlist.section_id
              xlist.short_name = parent_name
              xlist.long_name = parent_name
              xlist.full_name = parent_name
              
              xml = Xml_strings.open_xml(xlist)
              xml += xlist.create_xlist_course
              xlist.short_name = parent_name+children_name
              xlist.long_name = parent_name+children_name
              xlist.full_name = parent_name+children_name
              xml += xlist.create_xlist_section
              for child in children
                child.parent_source = xlist.source
                child.parent_id = xlist.section_id
                xml += child.add_member_section
              end # for child
              xml += Xml_strings.close_xml
              
              @res = Xml_client.post(xml).body.content
              if /success/.match(@res)
                redirect_to(:action => 'index', :res => "Created crosslist successfully.") and return
              else
                redirect_to(:action => 'index', :res => @res) and return
              end # if match
            else # if find section nil
              redirect_to(:action => "xlist_exists_already") and return
            end # if find section nil
          end # if check_permissions
        end # filter
      end # if empty
    end # if submit_check
  end # create_exec
  
  def add_list
    # This will display a list of sections available to add to an existing cross-list
    if filter(params[:term_id], params[:sect_id]) 
      if check_permissions(params[:sect_id])
        @sections = Section.find_non_xlisted_sections_by_primary_instructor_id_and_term_id(session[:on_behalf_of], params[:term_id])
      end # if check_permissions
    end # if filter
  end # add_list
  
  def add_exec
    if submit_check(params[:commit])
      if empty_param(params[:par_id], params[:add_sect])
        # This will add the params[:add_sect] to the xlist params[:par_id]
        if filter(params[:par_id], params[:add_sect])
          if check_permissions(params[:par_id], params[:add_sect])
            logger.info 'Add to crosslist, user: '+session[:user]+', parent: '+params[:par_id]+', adding: '+params[:add_sect].join(" ")
            section = Section.find_section_by_section_id(params[:par_id]).last
            
            sect_child_ary = Array.new
            for param in params[:add_sect]
              sect_child_ary << Section.find_section_by_section_id(param)
            end # for param
            sect_child_ary = sect_child_ary.flatten
            
            xml = Xml_strings.open_xml(section)
            for child in sect_child_ary
              child.parent_source = section.source
              child.parent_id = section.section_id
              xml += child.add_member_section
            end # for child
            xml += Xml_strings.close_xml
            
            @res = Xml_client.post(xml).body.content
            if /success/.match(@res)
              redirect_to(:action => 'index', :res => "Added section(s) successfully.") and return
            else
              redirect_to(:action => 'index', :res => @res) and return
            end # if match
          end # if check_permissions
        end # filter
      end # if empty
    end # if submit_check
  end # add_exec
  
  def rm_list
    # This will display a list of sections in the cross-list available for removal (excludes master child)
    if filter(params[:sect_id], params[:term_id])
      if check_permissions(params[:sect_id])
        section = Section.find_section_by_section_id(params[:sect_id]).last
        @children = Section.find_xlisted_sections_children_by_section_obj(section)
      end # if check_permissions
    end # filter
  end # rm_list
  
  def rm_exec
    if submit_check(params[:commit])
      if empty_param(params[:par_id], params[:sect_id])
        # This will remove the params[:sect_id] from the xlist params[:par_id]
        if filter(params[:par_id], params[:sect_id])
          if check_permissions(params[:par_id], params[:sect_id])
            logger.info 'Remove from crosslist, user: '+session[:user]+', parent: '+params[:par_id]+', removing: '+params[:sect_id].to_s
            parent = Section.find_section_by_section_id(params[:par_id]).last
            
            xml = Xml_strings.open_xml(parent)
            for id in params[:sect_id]
              child = Section.find_section_by_section_id(id).last
              child.parent_source = parent.source
              child.parent_id = parent.section_id
              xml += child.remove_member_section
            end # for id
            xml += Xml_strings.close_xml
            
            @res = Xml_client.post(xml).body.content
            if /success/.match(@res)
              redirect_to(:action => 'index', :res => "Removed section(s) successfully.") and return
            else
              redirect_to(:action => 'index', :res => @res) and return
            end # if match
          end # if check_permissions
        end # filter
      end # if empty
    end # if submit_check
  end # rm_exec
  
  def del_confirm
    # This will display a confirmation page for deleting the xlist
    if filter(params[:sect_id], params[:term_id])
      if check_permissions(params[:sect_id]): end
    end # if filter
  end # del_confirm
  
  def del_exec
    # This will delete a cross-listed section, putting it's master child on it's own
    if submit_check(params[:commit])
      if empty_param(params[:par_id])
        if filter(params[:par_id])
          if params[:del_confirm_field]=="delete"
            if check_permissions(params[:par_id])
              logger.info 'Delete crosslist, user: '+session[:user]+', deleting crosslist: '+params[:par_id]
              section = Section.find_section_by_section_id(params[:par_id]).last
              children = Section.find_xlisted_sections_children_by_section_obj(section)
              xml = Xml_strings.open_xml(section)
              for child in children
                child.parent_source = section.source
                child.parent_id = section.section_id
                xml += child.remove_member_section
              end # for child
              xml += section.delete_section
              xml += Xml_strings.close_xml
              @res = Xml_client.post(xml).body.content
              if /success/.match(@res)
                redirect_to(:action => 'index', :res => "Deleted crosslist successfully.") and return
              else
                redirect_to(:action => 'index', :res => @res) and return
              end # if match
            end # if check_permissions
          else # confirm not = delete
            redirect_to(:action => 'index') and return
          end # if confirm is delete
        end # if filter
      end # if empty
    end # if submit_check
  end # del_exec
  
  def xlist_exists_already
  end # xlist_exists_already
  
  
  
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
  
  def check_permissions(*sections_param)
    problem = false
    for sections in sections_param
      if sections.is_a?(Array)
        for section in sections
          db_sect_ary = Section.find_sections_by_primary_instructor_for_permission_checking(session[:on_behalf_of])
          if (db_sect_ary.select{|sect| sect.section_id == section}.empty?)
            problem = true
          end # if db_sec_ary select
        end # for sect
      else # sections not array
        db_sect_ary = Section.find_sections_by_primary_instructor_id(session[:on_behalf_of])
        if (db_sect_ary.select{|sect| sect.section_id == sections}.empty?)
          problem = true
        end # if db_sec_ary select
      end # if sections array
    end # for sections
    if problem
      redirect_to(:controller => "selfservice", :action => "permission") and return
    else
      return true
    end
  end # check_permissions
  
  def submit_check(commit)
    unless commit=="Add" or commit=="Remove" or commit=="Delete" or commit=="Submit" or commit=="Confirm"
      redirect_to(:action => "index") and return
    else
      return true
    end # unless commit
  end # submit_check
  
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
end # CrosslistController
