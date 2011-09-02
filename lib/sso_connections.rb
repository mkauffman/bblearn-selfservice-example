
module Sso_connections
   
  def admin_signon
    userId    = User.find_by_user_id(params[:sso_id]).batch_uid
    build_url(userId)
  end
  
  def designer_signon
    
  end
  
  def student_signon
    url = "#student"
  end

  def build_url(userId)
    host      = "lms-temp.csuchico.edu"
    block     = "/webapps/bbgs-autosignon-BBLEARN2/autoSignon.do"
    courseId  = Section.find_by_course_id(params[:section]).batch_uid
    timestamp = Time.now.to_i.to_s
    secret    = "3B1!ndM!ce..."
    
    auth = Digest::MD5.hexdigest(courseId+timestamp+userId+secret)

    url = "https://"+host+block
    url += "?courseId="+courseId
    url += "&timestamp="+timestamp
    url += "&userId="+userId
    url += "&auth="+auth    
  end
  
end