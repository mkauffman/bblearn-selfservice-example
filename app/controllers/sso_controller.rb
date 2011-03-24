class SsoController < ApplicationController
  # This controller allows support users to log in as an instructor, designer or student in a section.
  before_filter do |c|
    c.send(:is_authorized, [:super, :admin, :tlp, :tlp_admin, :stcp, :itss, :usrv, :mlib])
  end
  
  def index
  end
  
  def sections
    # This gets a list of sections the specified instructor is primary instructor in for the
    # specified term.
    # @selected_term is used by the drop down menu, defaults to current term
    # @terms is used for the drop down menu to switch between terms
    # @sections is used to show the selectable sections
    if filter(params[:portal_id])
      if empty_param(params[:portal_id])
        if Person.check_user_id_existence(params[:portal_id])
          unless (params[:term_sel].nil?)
            @selected_term = Term.find_term_by_term_id(params[:term_sel]).last
          else
            @selected_term = Term.find_current_term.last
          end
          
          @terms = Term.find_sso_terms
          @sections = Section.find_section_enrollment_by_user_id_and_term_id(params[:portal_id], @selected_term.term_id)
          @sections.each_with_index {|section, index|
            if Person.check_if_user_is_in_section(section.section_id, session[:user])
              @sections[index].delete
            end # if student nil
          } # @sections.each_index
        else # person doesn't exist
          redirect_to(:controller => "selfservice", :action => "portal_id_failure")
        end # if person exists
      end # if empty_param
    end # if filter
  end #sections
  
  def vista_login
    # This is called when the user has selected a section and a role to log in as
    # Check if they clicked submit or cancel
    if submit_check(params[:commit])
      # Check that all params are populated
      if empty_param(params[:section], params[:role], params[:portal_id])
        # Filter user input
        if filter(params[:section], params[:role], params[:portal_id])
          #check if the user is a student in the selected section
          if check_if_student(params[:section])
            sso_secret =  "53696D706C652053616D20536179732053776565742053757A792053686F756C64205361792053686520536C61707065642053696D706C652053616D"
            section = Section.find_section_by_section_id(params[:section]).last
            user = Person.find_person_by_webct_id(session[:user]).last
            
            # If the user is an admin, allow them to do anything by making inst true
            if ([:super, :admin].include?(session[:role]))
              tmp_user_id = 'tlp-'+session[:user]
            else
              # The user isn't an admin, so check if they should have rights to log in as an instructor or not
              tmp_user_id = session[:role].to_s+"-"+session[:user]
            end # if permission
            
            # Is the user trying to log in as the instructor and do they have permission to do so
            if (params[:role].to_s == 'spoof') and ([:super, :admin].include?(session[:role]))
              logger.info 'Admin user: '+session[:user]+' is using the SSO tool to spoof log in as: '+params[:portal_id]
              tmp_user_id = params[:portal_id]
            elsif (params[:role].to_s == 'student')
              # The user is logging in as a student, so create the fake student for them to log in as
              if [:super, :admin, :tlp, :tlp_admin, :itss].include?(session[:role])
                logger.info 'SSO as student, user: '+session[:user]+', section: '+params[:section]
                user.sourced_id = tmp_user_id+"-support-account-id"
                user.source = "WebCT"
                user.webct_id = tmp_user_id
                
                xml = Xml_strings.open_xml(section)
                xml += user.create_person
                xml += user.add_student(section)
                xml += Xml_strings.close_xml
                
                @res = Xml_client.post(xml).body.content
              end # if include role
            elsif (params[:role].to_s == 'designer')
              if [:super, :admin, :tlp, :tlp_admin].include?(session[:role])
                logger.info 'SSO as instructor designer, user: '+session[:user]+', section: '+params[:section]
                user.sourced_id = tmp_user_id+"-support-account-id"
                user.source = "WebCT"
                user.webct_id = tmp_user_id
                
                xml = Xml_strings.open_xml(section)
                xml += user.create_person
                xml += user.add_designer(section)
                xml += user.add_guest_instructor(section)
                xml += Xml_strings.close_xml
                
                @res = Xml_client.post(xml).body.content
              elsif [:mlib].include?(session[:role])
                logger.info 'SSO as designer, user: '+session[:user]+', section: '+params[:section]
                user.sourced_id = tmp_user_id+"-support-account-id"
                user.source = "WebCT"
                user.webct_id = tmp_user_id
                
                xml = Xml_strings.open_xml(section)
                xml += user.create_person
                xml += user.add_designer(section)
                xml += Xml_strings.close_xml
                
                @res = Xml_client.post(xml).body.content
              else # role not allowed to use the tool
                redirect_to(:controller => "selfservice", :action => "permission") and return
              end # if include role
            end # if params role
            
            @username = tmp_user_id
            @section = section.section_id
            @checksum = Digest::MD5.hexdigest(tmp_user_id+params[:section]+sso_secret)
            @lcid = section.lc_id
            @vista_url = AppConfig.view_my_webct_url
          end # unless student
        end # if filter
      end # if empty_param
    end # if submit_check
  end # def vistaLogin
  
  def is_student
  end # is_student
  
  
  ###################################### Private Methods ###########################################
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
    unless commit=="Submit": redirect_to(:action => "index") and return else return true end 
  end # submit_check
  
  def check_if_student(section_id)
    if Person.check_if_user_is_student_in_section(section_id, session[:user])
      redirect_to(:action => "is_student") and return
    else
      return true
    end # if student
  end # check_if_student
end #class
