require 'context_ws'
require 'course_membership_ws'
require 'course_ws'
require 'user_ws'

class Main

	con = ContextWS.new

	session_id = con.ws_initialize
	
	mem = CourseMembershipWS.new(session_id)
	crs = CourseWS.new(session_id)
	usr = UserWS.new(session_id)

    con.ws_login_tool
    con.ws_emulate_user
    crs.ws_course_initialize

end
	
	
