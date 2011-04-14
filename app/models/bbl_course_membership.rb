class BblCourseMembership < ActiveRecord::Base
  ########################################### Summary ###############################################
  # Includes                                                                                        #
  # Instance Methods                                                                                #
  # Queries                                                                                         #
  # Object Builder                                                                                  #
  ###################################################################################################

  ########################################### Includes ##############################################
  require 'rubygems'
  require 'savon'
  require 'gyoku'
  
  ########################################### Instance Methods ######################################
  # Summary of BblContext Instance Methods:                                                         #
  
  
  ########################################### Class Methods #########################################
  # Summary of BblContext Class Methods:                                                            #

  ########################################### Private Methods #######################################
  private
  def login_tool
    login_uniq = Time.now.strftime("course_mem_login_%m_%d_%Y_%H_%M_%S")
    
    login_resp = self.client.request :loginTool do
      wsse.credentials "session", self.session_id
      wsse.created_at = Time.now.utc + 10800
      wsse.expires_at = Time.now.utc + 10860
      soap.namespaces["xmlns:wsa"] = "http://www.w3.org/2005/08/addressing"
      soap.namespaces["xmlns:wsu"] = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"
      soap.namespaces["xmlns:bbl"] = "http://context.ws.blackboard"
      soap.header = { 
        "wsa:To" => AppConfig.bbl_course_mem_endpoint, 
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
  end # login_tool
  
  def ws_init
    # initializes the connection to the WS, returns a session_id that needs to be used in all
    # future calls to the context webservice. The session is used by setting the wsse.credentials to
    # 'wsse.credentials "session", session_id'
    init_uniq = Time.now.strftime("course_mem_initialize_%m_%d_%Y_%H_%M_%S")
    init_resp = self.client.request :initialize do  
      wsse.credentials "session", "nosession"
      wsse.created_at = Time.now.utc + 10800
      wsse.expires_at = Time.now.utc + 10860
      soap.namespaces["xmlns:wsa"] = "http://www.w3.org/2005/08/addressing"
      soap.namespaces["xmlns:wsu"] = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"
      soap.header = { 
        "wsa:To" => AppConfig.bbl_course_mem_endpoint, 
        "wsa:MessageID" => init_uniq, 
        "wsa:Action" => "initialize" 
      }
    end # @init_resp
    
    session_reg = /([^><]+)(?=<\/ns:return>)/
    session_id = session_reg.match(init_resp.http.body).to_s
    return session_id  
  end # ws_init
  
  def create_client
    # Creates a new savon connection agent to be used for making web service calls to the context
    # wsdl on the server.
    client = Savon::Client.new 
    client.wsdl.document = AppConfig.bbl_course_mem_document
    client.wsdl.endpoint = AppConfig.bbl_course_mem_endpoint
    client.wsdl.namespace = "http://context.ws.blackboard/"
    return client
  end # create_client
end
