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
      wsdl.document = "http://lms-temp.csuchico.edu/webapps/ws/services/Context.WS?wsdl"
    end
    
    @client.wsdl.endpoint = "http://lms-temp.csuchico.edu/webapps/ws/services/Context.WS"
    @client.wsdl.namespace = "http://context.ws.blackboard/"
    
    uniquestring = Time.now.strftime("context_initialize_2_%m_%d_%Y_%H_%M_%S")
    
    @response = @client.request :initialize do  
      wsse.credentials "session", "nosession"
      #wsse.timestamp = true
      wsse.created_at = Time.now.utc + 10800
      wsse.expires_at = Time.now.utc + 10860
      soap.namespaces["xmlns:wsa"] = "http://www.w3.org/2005/08/addressing"
      soap.namespaces["xmlns:wsu"] = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"
      soap.header = { "wsa:To" => "http://lms-temp.csuchico.edu/webapps/ws/services/Context.WS", "wsa:MessageID" => uniquestring, "wsa:Action" => "initialize" }
    end
    
    #puts response.to_xml;
    @newr = @response.to_hash
    #puts newr[:initialize_response][:return]
  end # form
end # Migration Controller
