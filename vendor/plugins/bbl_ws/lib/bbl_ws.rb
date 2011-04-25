# BblWs

class BblWs
  attr_accessor :user_to_emulate, :additional_seconds, :userid, :method, :password, :client_vendor_id
  attr_accessor :client_program_id, :login_extra_info, :expected_life_seconds, :ticket, :client, :session_id
  
  protected
  def initialize
    if self.client.nil?: self.client = client end
    if self.session_id.nil?: self.session_id = ws_init end
    unless self.logged_in: self.logged_in = tool_login end
  end
  
  def client
    # Creates a new savon connection agent to be used for making web service calls to the context
    # wsdl on the server.
    client = Savon::Client.new 
    client.wsdl.document = AppConfig.bbl_context_document
    client.wsdl.endpoint = AppConfig.bbl_context_endpoint
    client.wsdl.namespace = "http://context.ws.blackboard/"
    return client
  end # client
  
  def ws_init
    # initializes the connection to the WS, returns a session_id that needs to be used in all
    # future calls to the context webservice. The session is used by setting the wsse.credentials to
    # 'wsse.credentials "session", session_id'
    init_uniq = Time.now.strftime("context_initialize_%m_%d_%Y_%H_%M_%S")
    init_resp = self.client.request :initialize do  
      wsse.credentials "session", "nosession"
      wsse.created_at = Time.now.utc + 10800
      wsse.expires_at = Time.now.utc + 10860
      soap.namespaces["xmlns:wsa"] = "http://www.w3.org/2005/08/addressing"
      soap.namespaces["xmlns:wsu"] = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"
      soap.header = { 
        "wsa:To" => AppConfig.bbl_context_endpoint, 
        "wsa:MessageID" => init_uniq, 
        "wsa:Action" => "initialize" 
      }
    end # @init_resp
    
    session_reg = /([^><]+)(?=<\/ns:return>)/
    session_id = session_reg.match(init_resp.http.body).to_s
    return session_id  
  end # ws_init
  
  def tool_login
    login_uniq = Time.now.strftime("context_login_%m_%d_%Y_%H_%M_%S")
    
    login_resp = self.client.request :loginTool do
      wsse.credentials "session", self.session_id
      wsse.created_at = Time.now.utc + 10800
      wsse.expires_at = Time.now.utc + 10860
      soap.namespaces["xmlns:wsa"] = "http://www.w3.org/2005/08/addressing"
      soap.namespaces["xmlns:wsu"] = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"
      soap.namespaces["xmlns:bbl"] = "http://context.ws.blackboard"
      soap.header = { 
        "wsa:To" => AppConfig.bbl_context_endpoint, 
        "wsa:MessageID" => login_uniq, 
        "wsa:Action" => "loginTool"
      }
      soap.input = ["bbl:loginTool", {"xmlns:bbl" => "http://context.ws.blackboard"}]
      soap.body = "<bbl:password>#{AppConfig.bbl_tool_pass}</bbl:password>"
      soap.body += "<bbl:clientVendorId>CSU_CHICO</bbl:clientVendorId>"
      soap.body += "<bbl:clientProgramId>RAILS_BBL_SS</bbl:clientProgramId>"
      soap.body += "<bbl:loginExtraInfo></bbl:loginExtraInfo>"
      soap.body += "<bbl:expectedLifeSeconds>3600</bbl:expectedLifeSeconds>"
    end # @login_resp
    
    return true
  end # tool_login
end # module BblWs