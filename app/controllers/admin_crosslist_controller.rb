class AdminCrosslistController < ApplicationController
  # Check if the user has permissions to access the admin crosslist controller
  # Expire sessions older than 15 minutes so people can't hijack abandoned sessions
  before_filter do |c|
    c.send(:is_authorized, [:super, :admin])
    c.session_chk
  end
  
  # 
  def index
    # This adds sections to the database with the session id, this is what happens when search calls index
    unless params[:sections].nil?
      for param in params[:sections]
        sessioned_sects = Dbsession.find(:all, :conditions => "session_number = '"+session[:session_id]+"'")
        if (sessioned_sects.find{|sect| sect.section_id == param}.nil?)
          Dbsession.create(:session_number => session[:session_id], :section_id => param, :section_type => "parent")
        end # if sessioned_sects
        section = Section.find_section_by_section_id(param).last
        section_children = Section.find_xlisted_sections_children_by_section_obj(section)
        unless (section_children.empty?)
          for child in section_children
            Dbsession.create(:session_number => session[:session_id], :section_id => child.section_id, :section_type => "child", :section_parent => param)
          end # for child
        end # unless section_children nil
      end # for param
    end # unless params
    
    # This gets the section information for displaying
    @children = Hash.new
    @parents = Array.new
    parents = Dbsession.find(:all, :conditions => "session_number = '"+session[:session_id]+"' and section_type = 'parent'")
    children = Dbsession.find(:all, :conditions => "session_number = '"+session[:session_id]+"' and section_type = 'child'")
    for par in parents
      parent = Section.find_section_by_section_id(par.section_id)
      unless parent.empty?
        @parents << parent.last
      else
        remove_session_section(par.section_id)
      end
    end # for par
    for child in children
      ch = Section.find_section_by_section_id(child.section_id)
      unless ch.empty?
        if (@children[child.section_parent].nil?)
          @children[child.section_parent] = ch
        else
          @children[child.section_parent] << ch.last
        end # if @children
      else
        remove_session_section(child.section_id)
      end # unless ch empty
    end # for child
  end # index
  
  def search_form
    @terms = Term.find_sso_terms
    @current_term = Term.find_current_term.last
  end # search_form
  
  def search
    if submit_chk
      unless params[:section].nil?
        @sections = Section.find_section_by_like_section_id(params[:section])
      else
        @sections = Section.find_sections_by_like_primary_instructor_id_and_term_id(params[:instructor_id], params[:term])
      end # unless params
    end # if submit_chk
  end # search
  
  def section_mgmt
    # This function redirects based on which button was clicked, this is needed to handle multiple submit types in the form
    if (filter(params[:commit])) and (filter(params[:sect_id])) and (filter(params[:term_id]))
      if (params[:commit]=="Create")
        redirect_to(:action => "create_list", :sect_id => params[:sect_id], :term_id => params[:term_id]) and return
      elsif (params[:commit]=="Add")
        redirect_to(:action => "add_list", :sect_id => params[:sect_id], :term_id => params[:term_id]) and return
      elsif (params[:commit]=="Remove")
        redirect_to(:action => "remove_list", :sect_id => params[:sect_id], :term_id => params[:term_id]) and return
      elsif (params[:commit]=="Delete")
        redirect_to(:action => "del_confirm", :sect_id => params[:sect_id], :term_id => params[:term_id]) and return
      elsif (params[:commit]=="Rename")
        redirect_to(:action => "rename_form", :sect_id => params[:sect_id], :term_id => params[:term_id]) and return
      end # commit is create
    end # filter
  end # section_mgmt
  
  def create_list
    # This will display a list of available sections for cross-listing
    if filter(params[:term_id], params[:sect_id])
      if Section.find_section_by_section_id("xlist-"+params[:sect_id]).empty?
        @sections = Dbsession.find(:all, :conditions => "session_number = '"+session[:session_id]+"' and section_type = 'parent' and section_id != '"+params[:sect_id]+"'")
      else # if db_mgr
        redirect_to(:action => "xlist_exists_already") and return
      end # if db_mgr
    end # filter
  end # create_list
  
  def create_name
    if submit_chk
      if empty_param(params[:sect_id], params[:par_id])
        if Section.find_section_by_section_id("xlist-"+params[:par_id]).empty?
          child_reg = Regexp.new(/[a-zA-Z]{4}[0-9]{3}[A-Z]?-[0-9]{2}/)
          sem_reg = Regexp.new(/([0-9]{3})(?=-[a-zA-Z]{4}[0-9]{3}[A-Z]?-[0-9]{2})/)
          dept_reg = Regexp.new(/-[a-zA-Z]{4}[0-9]{3}[A-Z]?-[0-9]{2}/)
          parent = sem_reg.match(params[:par_id]).to_s+"X"+dept_reg.match(params[:par_id]).to_s
          children = ""
          iter = 0
          for id in params[:sect_id]
            if (iter < 3)
              child = child_reg.match(id).to_s
              children << ", "+child
              iter += 1
            else
              break
            end # if iter
          end # for id
          @parent_sourced_id = "xlist-"+sem_reg.match(params[:par_id]).to_s+dept_reg.match(params[:par_id]).to_s
          @name_first = parent
          @name_second = children
        else # if db_mgr
          redirect_to(:action => "xlist_exists_already") and return
        end # if db_mgr
      end # if empty_param
    end # if submit_chk
  end # create_name
  
  def create
    if submit_chk
      if empty_param(params[:name_first], params[:name_second], params[:par_id], params[:sect_id])
        # xml submission
        if Section.find_section_by_section_id("xlist-"+params[:par_id]).empty?
          logger.info 'Admin create crosslist, admin user: '+session[:user]+', crosslist: xlist-'+params[:par_id]+', children: '+params[:sect_id].to_s
          parent_id_reg = Regexp.new(/[0-9]{3}-[a-zA-Z]{4}[0-9]{3}[A-Z]?-[0-9]{2}/)
          xlist_name = params[:name_first]+params[:name_second]
          parent = Section.find_section_by_section_id(params[:par_id]).last
          parent_child = parent.clone
          parent_child.parent_id = "xlist-"+parent.section_id.to_s
          parent.template_parent_id = params[:par_id]
          parent.section_id = "xlist-"+parent.section_id
          parent.short_name = params[:name_first]
          parent.long_name = params[:name_first]
          parent.full_name = params[:name_first]
          
          
          xml = Xml_strings.open_xml(parent)
          xml += parent.create_xlist_course
          parent.short_name = params[:name_first]+params[:name_second]
          parent.long_name = params[:name_first]+params[:name_second]
          parent.full_name = params[:name_first]+params[:name_second]
          xml += parent.create_xlist_section
          xml += parent_child.add_member_section
          for child_id in params[:sect_id]
            child = Section.find_section_by_section_id(child_id).last
            child.parent_source = parent.source
            child.parent_id = parent.section_id
            xml += child.add_member_section
          end # for child
          xml += Xml_strings.close_xml
          
          @res = Xml_client.post(xml).body.content
          
          # session handling
          Dbsession.create(:session_number => session[:session_id], :section_id => "xlist-"+params[:par_id], :section_type => "parent", :section_parent => nil)
          parent = Dbsession.find(:first, :conditions => "session_number = '"+session[:session_id]+"' and section_id = '"+params[:par_id]+"'")
          parent.update_attributes(:section_type => "child", :section_parent => "xlist-"+params[:par_id])
          for child_id in params[:sect_id]
            child = nil
            child = Dbsession.find(:first, :conditions => "session_number = '"+session[:session_id]+"' and section_id = '"+child_id+"'")
            child.update_attributes(:section_type => "child", :section_parent => "xlist-"+params[:par_id])
          end # for child
          
          redirect_to(:action => "index", :response => @res) and return
        else # if xlist exists
          redirect_to(:action => "xlist_exists_already") and return
        end # if xlist exists
      end # if empty_param
    end # if submit_chk
  end # create
  
  def add_list
    @sections = Array.new
    sessioned_sects = Dbsession.find(:all, :conditions => "session_number = '"+session[:session_id]+"' and section_type = 'parent'")
    for section in sessioned_sects
      unless /xlist-/.match(section.section_id)
        @sections << Section.find_section_by_section_id(section.section_id).last
      end # unless xlist-
    end # for section
  end # add_list
  
  def add
    if submit_chk
      if empty_param(params[:add_sect], params[:par_id])
        logger.info 'Admin add to crosslist, user: '+session[:user]+', crosslist: '+params[:par_id]+', children: '+params[:add_sect].to_s
        parent = Section.find_section_by_section_id(params[:par_id]).last
        
        xml = Xml_strings.open_xml(parent)
        for param in params[:add_sect]
          child = Section.find_section_by_section_id(param).last
          child.parent_source = parent.source
          child.parent_id = parent.section_id
          
          xml += child.add_member_section
          session_child = Dbsession.find(:first, :conditions => "session_number = '"+session[:session_id]+"' and section_id = '"+param+"'")
          session_child.update_attributes(:section_type => "child", :section_parent => params[:par_id])
        end # for param
        xml += Xml_strings.close_xml
        
        @res = Xml_client.post(xml).body.content
        redirect_to(:action => "index", :response => @res) and return
      end # if empty_param
    end # if submit_chk
  end # add
  
  def remove_list
    section = Section.find_section_by_section_id(params[:sect_id]).last
    @children = Section.find_xlisted_sections_children_by_section_obj(section)
  end # remove_list
  
  def remove
    if submit_chk
      if empty_param(params[:par_id], params[:sect_id])
        logger.info 'Admin remove from crosslist, user: '+session[:user]+', crosslist: '+params[:par_id]+', children: '+params[:sect_id].to_s
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
        for child in params[:sect_id]
          removed_child = Dbsession.find(:first, :conditions => "session_number = '"+session[:session_id]+"' and section_id = '"+child+"'")
          removed_child.update_attributes(:section_type => "parent", :section_parent => nil)
        end # for child
        redirect_to(:action => "index", :response => @res) and return
      end # if empty_param
    end # if submit_chk
  end # remove
  
  def del_confirm
  end # del_confirm
  
  def delete
    if submit_chk
      if empty_param(params[:par_id])
        logger.info 'Admin delete crosslist, user: '+session[:user]+', deleting crosslist: '+params[:par_id]
        parent = Section.find_section_by_section_id(params[:par_id]).last
        children = Section.find_xlisted_sections_children_by_section_obj(parent)
        xml = Xml_strings.open_xml(parent)
        for child in children
          child.parent_source = parent.source
          child.parent_id = parent.section_id
          xml += child.remove_member_section
        end # for child
        xml += parent.delete_section
        xml += Xml_strings.close_xml
        @res = Xml_client.post(xml).body.content
        
        sections = Dbsession.find(:all, :conditions => "session_number = '"+session[:session_id]+"' and section_parent = '"+parent.section_id+"'")
        for sect in sections
          sect.update_attributes(:section_type => "parent", :section_parent => nil)
        end # for sect
        par = Dbsession.find(:first, :conditions => "session_number = '"+session[:session_id]+"' and section_id = '"+parent.section_id+"'")
        par.destroy
        
        redirect_to(:action => "index", :response => @res) and return
      end # if empty_param
    end # if submit_chk
  end # delete
  
  def rename_form
    if empty_param(params[:sect_id])
      @section = Section.find_section_by_section_id(params[:sect_id]).last
    end # if empty_param
  end # rename_form
  
  def rename
    if submit_chk
      if empty_param(params[:sect_id])
        unless params[:new_name].nil?
          logger.info 'Admin rename crosslist, user: '+session[:user]+', crosslist: '+params[:sect_id]+', new name: '+params[:new_name]
          section = Section.find_section_by_section_id(params[:sect_id]).last
          section.short_name = params[:new_name]
          section.long_name = params[:new_name]
          section.full_name = params[:new_name]
          
          if /xlist-/.match(section.section_id)
            xml = Xml_strings.open_xml(section)
            xml += section.update_xlist_course
            xml += Xml_strings.close_xml
            @res = Xml_client.post(xml).body.content
          else
            xml = Xml_strings.open_xml(section)
            xml += section.update_section
            xml += Xml_strings.close_xml
            @res = Xml_client.post(xml).body.content
          end # if /xlist-/
          
          redirect_to(:action => "index", :response => @res) and return
        else
          redirect_to(:action=>"rename_nil")  
        end # unless params
      end # if empty_param
    end # submit_chk
  end # rename
  
  def xlist_exists_already
  end # xlist_exists_already
  
  def clear_workspace
    sessions = Dbsession.find(:all, :conditions => "session_number = '"+session[:session_id]+"'")
    sessions.each do |s|
      s.destroy
    end # sessions each
    redirect_to(:action => "index") and return
  end # clear_workspace
  
  def session_chk
    expire_time = Time.now.utc - (60 * 20)
    sessions = Dbsession.find(:all, :group => "session_number")
    for sess in sessions
      newest_update = Dbsession.find(:first, :select=> "MAX(updated_at) as updated_at", :conditions => "session_number = '"+sess.session_number+"'").updated_at
      if (newest_update < expire_time): Dbsession.destroy_all(:session_number => sess.session_number) end
    end
  end # session_chk
  
  ############################### PRIVATE FUNCTIONS ######################################
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
  
  def submit_chk
    unless (params[:commit] == "Submit") or (params[:commit] == "Create") or (params[:commit] == "Search") or 
     (params[:commit] == "Confirm")
      redirect_to(:action => "index") and return
    else
      return true
    end # unless params
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
  
  def remove_session_section(section_id)
    section_session = Dbsession.find(:all, :conditions => "session_number = '"+session[:session_id]+"' and section_id = '"+section_id+"'")
    if section_session.is_a?(Array)
      for section_sess in section_session
        section_sess.destroy
      end # for section_session
    else
      section_session.destroy
    end # if section_session Array
  end # remove_session_section
end # AdminCrosslistController
