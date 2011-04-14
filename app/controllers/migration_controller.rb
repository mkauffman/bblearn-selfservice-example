class MigrationController < ApplicationController
  require 'rubygems'
  require 'savon'
  require 'gyoku'
  
  def index
    @sections = Section.find_sections_by_primary_instructor_id(session[:on_behalf_of])
    terms = Term.find_sso_terms
    @option_string = "<option></option>"
    for term in terms
      @option_string += "<option>"+term.description+"</option>"
    end # for term
  end # index
  
  def form
    @client = Savon::Client.new do
      wsdl.document = "https://lms-temp.csuchico.edu/webapps/ws/services/Context.WS?wsdl"
    end
    
    @client.wsdl.endpoint = "https://lms-temp.csuchico.edu/webapps/ws/services/Context.WS"
    @client.wsdl.namespace = "http://context.ws.blackboard/"

    init_uniq = Time.now.strftime("context_initialize_%m_%d_%Y_%H_%M_%S")
    
    @init_resp = @client.request :initialize do  
      wsse.credentials "session", "nosession"
      wsse.created_at = Time.now.utc + 10800
      wsse.expires_at = Time.now.utc + 10860
      soap.namespaces["xmlns:wsa"] = "http://www.w3.org/2005/08/addressing"
      soap.namespaces["xmlns:wsu"] = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"
      soap.header = { 
        "wsa:To" => "https://lms-temp.csuchico.edu/webapps/ws/services/Context.WS", 
        "wsa:MessageID" => init_uniq, 
        "wsa:Action" => "initialize" 
      }
    end # @init_resp
    
    session_reg = /([^><]+)(?=<\/ns:return>)/
    session_id = session_reg.match(@init_resp.http.body).to_s
    
    version_uniq = Time.now.strftime("context_version_%m_%d_%Y_%H_%M_%S")
    
    @version_resp = @client.request :getServerVersion do
      wsse.credentials "session", session_id
      wsse.created_at = Time.now.utc + 10800
      wsse.expires_at = Time.now.utc + 10860
      soap.namespaces["xmlns:wsa"] = "http://www.w3.org/2005/08/addressing"
      soap.namespaces["xmlns:wsu"] = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"
      soap.header = { 
        "wsa:To" => "https://lms-temp.csuchico.edu/webapps/ws/services/Context.WS", 
        "wsa:MessageID" => version_uniq, 
        "wsa:Action" => "getServerVersion" 
      }
      soap.input = ["getServerVersion", {"xmlns" => "http://context.ws.blackboard"}]
    end
    
    register_uniq = Time.now.strftime("context_register_%m_%d_%Y_%H_%M_%S")
    
    @register_resp = @client.request :registerTool do
      wsse.credentials "session", session_id
      wsse.created_at = Time.now.utc + 10800
      wsse.expires_at = Time.now.utc + 10860
      soap.namespaces["xmlns:wsa"] = "http://www.w3.org/2005/08/addressing"
      soap.namespaces["xmlns:wsu"] = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"
      soap.header = { 
        "wsa:To" => "https://lms-temp.csuchico.edu/webapps/ws/services/Context.WS", 
        "wsa:MessageID" => register_uniq, 
        "wsa:Action" => "registerTool" 
      }
      soap.input = ["ns:registerTool", {"xmlns:ns3" => "http://context.ws.blackboard"}]
      soap.body = "<ns3:registerTool xmlns:ns3=\"http://context.ws.blackboard\">"
        soap.body += "<ns3:clientVendorId>CSU_CHICO</ns3:clientVendorId>"
        soap.body += "<ns3:clientProgramId>RAILS_BBL_SS</ns3:clientProgramId>"
        soap.body += "<ns3:registrationPassword>pass1234</ns3:registrationPassword>"
        soap.body += "<ns3:description>Migration tool web service consumer</ns3:description>"
        soap.body += "<ns3:initialSharedSecret>atec!d1rn</ns3:initialSharedSecret>"
        soap.body += "<ns3:requiredToolMethods>Context.WS:emulateUser</ns3:requiredToolMethods>"
        soap.body += "<ns3:requiredToolMethods>Context.WS:logout</ns3:requiredToolMethods>"
        soap.body += "<ns3:requiredToolMethods>Context.WS:getMemberships</ns3:requiredToolMethods>"
        soap.body += "<ns3:requiredToolMethods>Context.WS:getServerVersion</ns3:requiredToolMethods>"
        soap.body += "<ns3:requiredToolMethods>Context.WS:initialize</ns3:requiredToolMethods>"
        soap.body += "<ns3:requiredToolMethods>Context.WS:loginTool</ns3:requiredToolMethods>"
        soap.body += "<ns3:requiredToolMethods>Context.WS:registerTool</ns3:requiredToolMethods>"
      soap.body += "</ns3:registerTool>"
    end # @register_resp
  end # form
  
  def login
    @client = Savon::Client.new 
    @client.wsdl.document = AppConfig.bbl_context_document
    @client.wsdl.endpoint = AppConfig.bbl_context_endpoint
    @client.wsdl.namespace = "http://context.ws.blackboard/"
    
    init_uniq = Time.now.strftime("context_initialize_%m_%d_%Y_%H_%M_%S")
    
    @init_resp = @client.request :initialize do  
      wsse.credentials "session", "nosession"
      wsse.created_at = Time.now.utc + 10800
      wsse.expires_at = Time.now.utc + 10860
      soap.namespaces["xmlns:wsa"] = "http://www.w3.org/2005/08/addressing"
      soap.namespaces["xmlns:wsu"] = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"
      soap.header = { 
        "wsa:To" => "https://lms-temp.csuchico.edu/webapps/ws/services/Context.WS", 
        "wsa:MessageID" => init_uniq, 
        "wsa:Action" => "initialize" 
      }
    end # @init_resp
    
    session_reg = /([^><]+)(?=<\/ns:return>)/
    session_id = session_reg.match(@init_resp.http.body).to_s
    
    login_uniq = Time.now.strftime("context_login_%m_%d_%Y_%H_%M_%S")
    
    @login_resp = @client.request :loginTool do
      wsse.credentials "session", session_id
      wsse.created_at = Time.now.utc + 10800
      wsse.expires_at = Time.now.utc + 10860
      soap.namespaces["xmlns:wsa"] = "http://www.w3.org/2005/08/addressing"
      soap.namespaces["xmlns:wsu"] = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"
      soap.namespaces["xmlns:bbl"] = "http://context.ws.blackboard"
      soap.header = { 
        "wsa:To" => "https://lms-temp.csuchico.edu/webapps/ws/services/Context.WS", 
        "wsa:MessageID" => login_uniq, 
        "wsa:Action" => "loginTool"
      }
      soap.input = ["bbl:loginTool", {"xmlns:bbl" => "http://context.ws.blackboard"}]
      soap.body = "<bbl:password>atec!d1rn</bbl:password>"
      soap.body += "<bbl:clientVendorId>CSU_CHICO</bbl:clientVendorId>"
      soap.body += "<bbl:clientProgramId>RAILS_BBL_SS</bbl:clientProgramId>"
      soap.body += "<bbl:loginExtraInfo></bbl:loginExtraInfo>"
      soap.body += "<bbl:expectedLifeSeconds>3600</bbl:expectedLifeSeconds>"
    end # @login_resp
    
    mem_uniq = Time.now.strftime("context_memberships_%m_%d_%Y_%H_%M_%S")
    
    @memberships_resp = @client.request :getMemberships do
      wsse.credentials "session", session_id
      wsse.created_at = Time.now.utc + 10800
      wsse.expires_at = Time.now.utc + 10860
      soap.namespaces["xmlns:wsa"] = "http://www.w3.org/2005/08/addressing"
      soap.namespaces["xmlns:wsu"] = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"
      soap.namespaces["xmlns:bbl"] = "http://context.ws.blackboard"
      soap.header = { 
        "wsa:To" => "https://lms-temp.csuchico.edu/webapps/ws/services/Context.WS", 
        "wsa:MessageID" => mem_uniq, 
        "wsa:Action" => "getMemberships"
      }
      soap.input = ["bbl:getMemberships", {"xmlns:bbl" => "http://context.ws.blackboard"}]
      soap.body = "<bbl:userid>@mkauffman</bbl:userid>"
    end # @login_resp
  end # login
  
  def modeltest
    @context = BblContext.new
    @context.client = @context.create_client
    @context.session_id = @context.ws_init
  end # modeltest
end # Migration Controller
