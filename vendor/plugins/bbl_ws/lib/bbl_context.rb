class BblContext < BblWs
  def initialize
    super
  end # initialize
  
  def get_memberships(userid)
    if self.client.nil?: self.client = create_client end
    if self.session_id.nil?: self.session_id = ws_init end
    unless self.logged_in: self.logged_in = login_tool end
    
    mem_uniq = Time.now.strftime("context_memberships_%m_%d_%Y_%H_%M_%S")
    mem_resp = self.client.request :getMemberships do
      wsse.credentials "session", self.session_id
      wsse.created_at = Time.now.utc + 10800
      wsse.expires_at = Time.now.utc + 10860
      soap.namespaces["xmlns:wsa"] = "http://www.w3.org/2005/08/addressing"
      soap.namespaces["xmlns:wsu"] = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"
      soap.namespaces["xmlns:bbl"] = "http://context.ws.blackboard"
      soap.header = { 
        "wsa:To" => AppConfig.bbl_context_endpoint, 
        "wsa:MessageID" => mem_uniq, 
        "wsa:Action" => "getMemberships"
      }
      soap.input = ["bbl:getMemberships", {"xmlns:bbl" => "http://context.ws.blackboard"}]
      soap.body = "<bbl:userid>#{userid}</bbl:userid>"
    end # @login_resp
    
    return mem_resp
  end # get_memberships
  
  def register_tool
    register_uniq = Time.now.strftime("context_register_%m_%d_%Y_%H_%M_%S")
    
    register_resp = self.client.request :registerTool do
      wsse.credentials "session", self.session_id
      wsse.created_at = Time.now.utc + 10800
      wsse.expires_at = Time.now.utc + 10860
      soap.namespaces["xmlns:wsa"] = "http://www.w3.org/2005/08/addressing"
      soap.namespaces["xmlns:wsu"] = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"
      soap.header = { 
        "wsa:To" => AppConfig.bbl_context_endpoint, 
        "wsa:MessageID" => register_uniq, 
        "wsa:Action" => "registerTool" 
      }
      soap.input = ["ns:registerTool", {"xmlns:ns3" => "http://context.ws.blackboard"}]
      soap.body = "<ns3:registerTool xmlns:ns3=\"http://context.ws.blackboard\">"
        soap.body += "<ns3:clientVendorId>CSU_CHICO</ns3:clientVendorId>"
        soap.body += "<ns3:clientProgramId>RAILS_BBL_SS</ns3:clientProgramId>"
        soap.body += "<ns3:registrationPassword>#{AppConfig.bbl_registration_pass}</ns3:registrationPassword>"
        soap.body += "<ns3:description>Migration tool web service consumer</ns3:description>"
        soap.body += "<ns3:initialSharedSecret>#{AppConfig.bbl_tool_pass}</ns3:initialSharedSecret>"
        soap.body += "<ns3:requiredToolMethods>Context.WS:getMemberships</ns3:requiredToolMethods>"
        soap.body += "<ns3:requiredToolMethods>Course.WS:createCourse</ns3:requiredToolMethods>"
        soap.body += "<ns3:requiredToolMethods>Course.WS:deleteCourse</ns3:requiredToolMethods>"
        soap.body += "<ns3:requiredToolMethods>Course.WS:saveCourse</ns3:requiredToolMethods>"
        soap.body += "<ns3:requiredToolMethods>Course.WS:updateCourse</ns3:requiredToolMethods>"
        soap.body += "<ns3:requiredToolMethods>Course.WS:saveCourseCategoryMembership</ns3:requiredToolMethods>"
        soap.body += "<ns3:requiredToolMethods>CourseMembership.WS:saveCourseMembership</ns3:requiredToolMethods>"
        soap.body += "<ns3:requiredToolMethods>CourseMembership.WS:updateCourse</ns3:requiredToolMethods>"
        soap.body += "<ns3:requiredToolMethods>CourseMembership.WS:getCourseMembership</ns3:requiredToolMethods>"
        soap.body += "<ns3:requiredToolMethods>User.WS:saveUser</ns3:requiredToolMethods>"
        soap.body += "<ns3:requiredToolMethods>User.WS:getUser</ns3:requiredToolMethods>"
        soap.body += "<ns3:requiredToolMethods>Content.WS:addContentFile</ns3:requiredToolMethods>"
        soap.body += "<ns3:requiredToolMethods>Content.WS:deleteContentFiles</ns3:requiredToolMethods>"
      soap.body += "</ns3:registerTool>"
    end # @register_resp
    
    resp_content = /([^>]+)(?=<\/ax28:status>)/.match(register_resp.http.body).to_s
    if resp_content == "true"
      return true 
    else 
      return /([^>]+)(?=<\/ax28:failureErrors>)/.match(register_resp.http.body).to_s
    end
  end # register_tool
end # class BblContext