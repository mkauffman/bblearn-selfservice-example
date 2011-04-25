class MigrationController < ApplicationController
  require 'rubygems'
  require 'savon'
  require 'gyoku'
  
  def index
    @sections = Section.find_sections_by_primary_instructor_id(session[:on_behalf_of])
    
    sql = "SELECT * FROM BBL_MIGRATION bbl WHERE bbl.sourcedid = :sourcedid"
    cursor = $vista_db_conn.parse(sql)
    
    @sections.each_index do |i|
      cursor.bind_param(':sourcedid', @sections[i].section_id).exec
      while rs_row = cursor.fetch_hash do
        @sections[i].status = rs_row['STATUS']
      end # while rs_row
    end # for section
    
    terms = Term.find_sso_terms
    @option_string = "<option></option>"
    for term in terms
      @option_string += "<option>"+term.description+"</option>"
    end # for term
  end # index
  
  def form
    sql = "INSERT INTO bbl_migration (timestamp, sourcedid, webctid, status, lastname, firstname) VALUES "
    sql += "(:timestamp, :sourcedid, :webctid, :status, :lastname, :firstname)"
    
    cursor = $vista_db_conn.parse(sql)
    
    for section_id in params[:sections]
      section = Section.find_section_by_section_id(section_id).first
      user = Person.find_person_by_webct_id(session[:on_behalf_of]).first
      
      cursor.bind_param(':timestamp', Time.now.strftime("%Y%m%d%H%M%S"))
      cursor.bind_param(':sourcedid', section.section_id)
      cursor.bind_param(':webctid', session[:on_behalf_of])
      cursor.bind_param(':status', "pending")
      cursor.bind_param(':lastname', user.last_name)
      cursor.bind_param(':firstname', user.first_name)
      response = cursor.exec
      $vista_db_conn.commit
    end # for param
    redirect_to :action => "index" and return
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
  
  def create_user_test
    context = BblContext.new.log_in
    
    body_str = String.new
    body_str += "<user:user>"
    body_str += "<xsd:dataSourceId>DATASOURCEID</xsd:dataSourceId>"
    body_str += "<xsd:extendedInfo>"
    body_str += "<xsd:emailAddress>EMAIL</xsd:emailAddress>"
    body_str += "<xsd:familyName>FAMILYNAME</xsd:familyName>"
    body_str += "<xsd:givenName>GIVENNAME</xsd:givenName>"
    body_str += "</xsd:extendedInfo>"
    body_str += "<xsd:genderType>GENDER</xsd:genderType>"
    body_str += "</user:user>"
    
    body_str = body_str.gsub(/DATASOURCEID/, "DLT Selfservice Tool")
    body_str = body_str.gsub(/EMAIL/, "johndoe@example.com")
    body_str = body_str.gsub(/FAMILYNAME/, "Doe")
    body_str = body_str.gsub(/GIVENNAME/, "John")
    body_str = body_str.gsub(/GENDER/, "M")
    
    create_uniq = Time.now.strftime("create_user_%m_%d_%Y_%H_%M_%S")
    @create_user_resp = context.client.request :saveUser do
      wsse.credentials "session", context.session_id
      wsse.created_at = Time.now.utc + 10800
      wsse.expires_at = Time.now.utc + 10860
      soap.namespaces["xmlns:wsa"] = "http://www.w3.org/2005/08/addressing"
      soap.namespaces["xmlns:wsu"] = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"
      soap.namespaces["xmlns:user"] = "http://user.ws.blackboard"
      soap.namespaces["xmlns:xsd"] = "http://user.ws.blackboard/xsd"
      soap.header = { 
        "wsa:To" => "https://lms-temp.csuchico.edu/webapps/ws/services/User.WS", 
        "wsa:MessageID" => create_uniq, 
        "wsa:Action" => "saveUser"
      }
      soap.input = "user:saveUser"
      soap.body = body_str
    end # @create_user_resp
  end # create_user_test
  
  def get_user_test
    @get_user_resp = BblUser.new.get_user("@mcarlson13")
  end # get_user_test
  
  def modeltest
    @register_resp = BblContext.new.register_tool
  end # modeltest
end # Migration Controller
