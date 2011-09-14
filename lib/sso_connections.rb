
module Sso_connections
  
  # TODO: Determine the difference between Designer & Student, and how the old
  #       MLIB permissions will factor in (role, not a permission group)
   
  def admin_signon
    batchId = User.find_by_user_id(params[:sso_id]).batch_uid
    build_url(batchId)
  end
  
  def designer_signon
    user = User.find_by_user_id(params[:sso_id])   
    prefix = InstitutionRole.find(user.institution_roles_pk1).role_name + "-"
    User.create(prefix, user.user_id)
    # TODO: Add some validation to make sure our temp user is created before trying to login as them:
    batchID = User.find_by_user_id(prefix + user.user_id)
    build_url(prefix + batchId)
  end
  
  def student_signon
    url = "#student"
  end

  def build_url(batchId)
    host      = "lms-temp.csuchico.edu"
    block     = "/webapps/bbgs-autosignon-BBLEARN2/autoSignon.do"
    courseId  = Section.find_by_course_id(params[:section]).batch_uid
    timestamp = Time.now.to_i.to_s
    secret    = "3B1!ndM!ce..."
    
    auth = Digest::MD5.hexdigest(courseId+timestamp+userId+secret)

    url = "https://"+host+block
    url += "?courseId="+courseId
    url += "&timestamp="+timestamp
    url += "&userId="+batchId
    url += "&auth="+auth    
  end
  
end