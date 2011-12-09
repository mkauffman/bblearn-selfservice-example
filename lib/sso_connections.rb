
module Sso_connections

  def create_sso_user(sso_user_id)
    
    sso_user            = User.new
    sso_user.student_id = sso_user_id
    sso_user.user_id    = sso_user_id
    sso_user.passwd     = "#{AppConfig.bbl_sso_password}"
    lastname            = session[:user_object].lastname + "(" 
    sso_user.lastname   = lastname + session[:user_object].sso_role.role_name + ")"
    sso_user.firstname  = session[:user_object].firstname
    sso_user.batch_uid  = sso_user_id + "-support-account-id"
      
    sso_user.save!
      
  end
  
  def create_sso_user_id
    user        = User.find_by_user_id(session[:user])
    prefix      = user.sso_role.role_id + "-"
    user_id     = prefix + user.user_id
  end
  
  def user_is_enrolled?(sso_user,section)
    if SectionRole.find_by_users_pk1_and_crsmain_pk1(sso_user.pk1, section.pk1).nil?
      true
    else
      false
    end
  end
  
  def destroy_section_role(sso_user,section)
   section_role = SectionRole.find_by_users_pk1_and_crsmain_pk1(sso_user.pk1, section.pk1)
   section_role.destroy
  end
  
  def create_and_add_sso(role_id,section)
    
    sso_user_id = create_sso_user_id

    create_sso_user(sso_user_id) if User.find_by_user_id(sso_user_id).nil?
    
    sso_user  = User.find_by_user_id(sso_user_id)

    if user_is_enrolled?(sso_user,section)
      SectionRole.create(section.pk1, sso_user.pk1, role_id)
    end
    build_url(sso_user)
  end

  def admin_signon
    batch_id = User.find_by_user_id(params[:sso_id])
    build_url(batch_id)
  end

  def designer_signon(section)
    create_and_add_sso('gi',section)
  end

  def student_signon(section)
    create_and_add_sso('S',section)
  end

  def build_url(batch_id)
    host      = AppConfig.bbl_ws_domain
    block     = "/webapps/bbgs-autosignon-#{AppConfig.bbl_db_table}/autoSignon.do"
    course_id = Section.find_by_course_id(params[:section]).batch_uid
    timestamp = Time.now.to_i.to_s
    secret    = "#{AppConfig.bbl_sso_secret}"

    user_id   = batch_id.user_id.to_s

    logger.info "LOGGING FOR SSO "+ course_id + ' ' + timestamp + ' ' + user_id

    auth = Digest::MD5.hexdigest(course_id+timestamp+user_id+secret)

    url = "https://"+host+block
    url += "?courseId="+course_id
    url += "&timestamp="+timestamp
    url += "&userId="+user_id
    url += "&auth="+auth
  end

end

