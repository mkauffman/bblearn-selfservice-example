class BblUser < ActiveRecord::Base
  def get_user(userid)
    @user_client = create_user_client
    $session = user_init
    context = BblContext.log_in
    
    body_str = String.new
    body_str += "<user:filter>"
    body_str += "<xsd:id>USERID</xsd:id>"
    body_str += "</user:filter>"
    
    body_str = body_str.gsub(/USERID/, userid)
    
    get_user_uniq = Time.now.strftime("get_user_%m_%d_%Y_%H_%M_%S")
    @get_user_resp = @user_client.request :getUser do
      wsse.credentials "session", context.session_id
      wsse.created_at = Time.now.utc + 10800
      wsse.expires_at = Time.now.utc + 10860
      soap.namespaces["xmlns:wsa"] = "http://www.w3.org/2005/08/addressing"
      soap.namespaces["xmlns:wsu"] = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"
      soap.namespaces["xmlns:user"] = "http://user.ws.blackboard"
      soap.namespaces["xmlns:xsd"] = "http://user.ws.blackboard/xsd"
      soap.header = { 
        "wsa:To" => "https://lms-temp.csuchico.edu/webapps/ws/services/User.WS", 
        "wsa:MessageID" => get_user_uniq, 
        "wsa:Action" => "getUser"
      }
      soap.input = "user:getUser"
      soap.body = body_str
    end # @create_user_resp
  end # get_user
  
  
  
  private
  def user_init
    # initializes the connection to the WS, returns a session_id that needs to be used in all
    # future calls to the context webservice. The session is used by setting the wsse.credentials to
    # 'wsse.credentials "session", session_id'
    init_uniq = Time.now.strftime("user_initialize_%m_%d_%Y_%H_%M_%S")
    init_resp = @user_client.request :initializeContentWS do  
      wsse.credentials "session", "nosession"
      wsse.created_at = Time.now.utc + 10800
      wsse.expires_at = Time.now.utc + 10860
      soap.namespaces["xmlns:wsdl"] = "http://content.ws.blackboard/"
      #soap.namespaces["xmlns:user"] = "http://user.ws.blackboard/"
      #soap.namespaces["xmlns:xsd"] = "http://user.ws.blackboard/xsd"
      soap.namespaces["xmlns:wsa"] = "http://www.w3.org/2005/08/addressing"
      soap.namespaces["xmlns:wsu"] = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"
      soap.header = { 
        "wsa:To" => AppConfig.bbl_content_endpoint, 
        "wsa:MessageID" => init_uniq, 
        "wsa:Action" => "initializeContentWS" 
      }
    end # @init_resp
    
    session_reg = /([^><]+)(?=<\/ns:return>)/
    session_id = session_reg.match(init_resp.http.body).to_s
    return session_id 
  end # user_init
  
  def create_user_client
    # Creates a new savon connection agent to be used for making web service calls to the context
    # wsdl on the server.
    client = Savon::Client.new 
    client.wsdl.document = AppConfig.bbl_content_document
    client.wsdl.endpoint = AppConfig.bbl_content_endpoint
    client.wsdl.namespace = "http://content.ws.blackboard/"
    return client
  end # user_client
end # BblUser
