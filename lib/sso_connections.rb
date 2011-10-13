
module Sso_connections

  # TODO: Determine the difference between Designer & Student, and how the old
  #       MLIB permissions will factor in (role, not a permission group)


  def create_and_add_sso(role_id,section)
    user        = User.find_by_user_id(params[:sso_id])
    prefix      = "sso-tlp-"
    user_id     = prefix + user.user_id.to_s
    if User.find_by_user_id(user_id).nil?
      User.create(prefix + user.user_id)
    end
    batch_id    = User.find_by_user_id(user_id)
    logger.info "BATCH: "+batch_id.pk1.to_s
    logger.info "SECTION: "+section.pk1.to_s
#TODO: Make a check for section role before creating
    role        = SectionRole.find_by_users_pk1_and_crsmain_pk1(batch_id.pk1, section.pk1)
    if role.nil?
      SectionRole.create(section.pk1, batch_id.pk1, role_id)
    else
      SectionRole.destroy(role)
      SectionRole.create(section.pk1, batch_id.pk1, role_id)
    end
    build_url(batch_id)
  end

  def admin_signon
    batchId = User.find_by_user_id(params[:sso_id])
    build_url(batchId)
  end

  def designer_signon(section)
    create_and_add_sso('gi',section)
  end

  def student_signon(section)
    create_and_add_sso('S',section)
  end

  def build_url(batchId)
    host      = AppConfig.bbl_ws_domain
    block     = "/webapps/bbgs-autosignon-#{AppConfig.bbl_db_table}/autoSignon.do"
    courseId  = Section.find_by_course_id(params[:section]).batch_uid
    timestamp = Time.now.to_i.to_s
    secret    = "3B1!ndM!ce..."

    user_id   = batchId.user_id.to_s

    logger.info "LOGGING FOR SSO "+ courseId + ' ' + timestamp + ' ' + user_id

    auth = Digest::MD5.hexdigest(courseId+timestamp+user_id+secret)

    url = "https://"+host+block
    url += "?courseId="+courseId
    url += "&timestamp="+timestamp
    url += "&userId="+user_id
    url += "&auth="+auth
  end

end

