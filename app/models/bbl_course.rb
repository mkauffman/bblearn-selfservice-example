class BblCourse < ActiveRecord::Base
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
  # Summary of BblCourse Instance Methods:                                                          #
  def create_course    
    if $session_id.nil?: $session_id = BblContext.log_in end
      
    course_uniq = Time.now.strftime("course_create_course_%m_%d_%Y_%H_%M_%S")
    course_resp = self.client.request :getMemberships do
      wsse.credentials "session", self.session_id
      wsse.created_at = Time.now.utc + 10800
      wsse.expires_at = Time.now.utc + 10860
      soap.namespaces["xmlns:wsa"] = "http://www.w3.org/2005/08/addressing"
      soap.namespaces["xmlns:wsu"] = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"
      soap.namespaces["xmlns:bbl"] = "http://context.ws.blackboard"
      soap.header = { 
        "wsa:To" => AppConfig.bbl_course_endpoint, 
        "wsa:MessageID" => course_uniq, 
        "wsa:Action" => "getMemberships"
      }
      soap.input = ["bbl:getMemberships", {"xmlns:bbl" => "http://context.ws.blackboard"}]
      soap.body = "<bbl:userid>#{userid}</bbl:userid>"
    end # @login_resp
    
    return course_resp
  end # create_course
  
  ########################################### Class Methods #########################################
  # Summary of BblCourse Class Methods:                                                             #

  ########################################### Private Methods #######################################
  private
  def create_client
    # Creates a new savon connection agent to be used for making web service calls to the context
    # wsdl on the server.
    client = Savon::Client.new 
    client.wsdl.document = AppConfig.bbl_course_document
    client.wsdl.endpoint = AppConfig.bbl_course_endpoint
    client.wsdl.namespace = "http://context.ws.blackboard/"
    return client
  end # create_client
end
