class SsoController < ApplicationController
  before_filter do |c|
    #c.send(:is_authorized, [:super, :admin, :tlp, :tlp_admin, :stcp, :itss, :usrv, :mlib])
  end
  
  def index
  end
  
  def sections
    if User.find_by_user_id(params[:sso_id])
      sso = User.find_by_user_id(params[:sso_id])
      @sections = SectionRole.find_by_id_comparison(sso.pk1, session[:users_pk1])
      if @sections.empty?
        redirect_to(:controller => "application", :action => "no_valid_sections")
      end
    else
      redirect_to(:controller => "application", :action => "portal_id_failure")
    end
  end
  
  def login
    if check_if_student(params[:section])
      sso_secret =  "53696D706C652053616D20536179732053776565742053757A792053686F756C64205361792053686520536C61707065642053696D706C652053616D"
      section = Section.find_section_by_section_id(params[:section]).last
      user = Person.find_person_by_webct_id(session[:user]).last
            
      #if ([:admin].include?(session[:role]))
      #        tmp_user_id = 'tlp-'+session[:user]
      #      else
              # Check if they should have rights to login as an instructor or not
              tmp_user_id = session[:role].to_s+"-"+session[:user]
      #      end # if permission
            
            # Is the user trying to login as the instructor and do they have permission to do so
            if (params[:role].to_s == 'spoof') and ([:super, :admin].include?(session[:role]))
              logger.info 'Admin user: '+session[:user]+' is using the SSO tool to spoof log in as: '+params[:sso_id]
              tmp_user_id = params[:sso_id]
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
            @url = AppConfig.view_my_webct_url
          end # unless student
  end
  
  ###################################### Private Methods ###########################################
  private
 
  def check_if_student(section_id)
    if Person.check_if_user_is_student_in_section(section_id, session[:user])
      redirect_to(:action => "index") and return
    else
      return true
    end # if student
  end # check_if_student
end #class
