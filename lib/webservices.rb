
module Webservices

  def ws_token
      con   = ContextWS.new
      token = con.ws
      con.login_tool
      con.emulate_user
      return token
  end

  def ws_section
      sec   = SectionWS.new(ws_token)
      sec.ws
      return sec
  end

  def section_web_service
      con            = ContextWS.new
      token          = con.ws
      con.login_tool
      con.emulate_user
      ws_section = SectionWS.new(token)
      ws_section.ws
      ws_section
  end

end

