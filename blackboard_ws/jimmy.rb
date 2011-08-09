require 'context_ws'

class Main

	foo = ContextWS.new
	session_id = foo.ws_initialize

  foo.ws_login_tool
  foo.ws_emulate_user

end
	
	
