
module Sso_connections

  # TODO: Determine the difference between Designer & Student, and how the old
  #       MLIB permissions will factor in (role, not a permission group)


  def create_and_add_sso(role,section)
    user        = User.find_by_user_id(params[:sso_id])
    prefix      = InstitutionRole.find(user.institution_roles_pk1).role_name + "-"
    User.create(prefix + user.user_id)
    user_id     = prefix.downcase! + user.user_id.to_s
    batchID     = User.find_by_user_id(user_id)
    SectionRole.create(section.pk1, batchID.pk1, role)
    build_url(batchID)
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
    host      = "lms-temp.csuchico.edu"
    block     = "/webapps/bbgs-autosignon-BBLEARN2/autoSignon.do"
    courseId  = Section.find_by_course_id(params[:section]).batch_uid
    timestamp = Time.now.to_i.to_s
    secret    = "3B1!ndM!ce..."

    user_id   = batchId.user_id.to_s

    logger.info "LOGGING FOR SSO "+ courseId + ' ' + timestamp + ' ' + user_id + ' ' + secret

    auth = Digest::MD5.hexdigest(courseId+timestamp+user_id+secret)

    url = "https://"+host+block
    url += "?courseId="+courseId
    url += "&timestamp="+timestamp
    url += "&userId="+user_id
    url += "&auth="+auth
  end

end

