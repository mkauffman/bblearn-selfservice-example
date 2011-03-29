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

  def migrate
    client = Savon::Client.new do
      wsdl.document = "http://"
    end
  end # migrate

  def form
    @client = Savon::Client.new do
      wsdl.document = "https://lms-temp.csuchico.edu/webapps/ws/services/Context.WS?wsdl"
      wsdl.endpoint = "https://lms-temp.csuchico.edu/webapps/ws/services/Context.WS"
      wsdl.namespace = "http://context.ws.blackboard/" 
    end
    
    @response = @client.request :initialize do  
      @wsse.credentials "session", "nosession"
      @wsse.timestamp = true
      @soap.namespaces["xmlns:wsa"] = "http://www.w3.org/2005/08/addressing"
      @soap.namespaces["xmlns:wsu"] = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"
      @soap.header = { "wsa:To" => "https://lms-temp.csuchico.edu/webapps/ws/services/Context.WS", "wsa:MessageID" => "urn:uuid:182F29861349EF02E01251997573947", "wsa:Action" => "initialize" }
    end
    
    #puts response.to_xml;
    @newr = response.to_hash
    #puts newr[:initialize_response][:return]
  end # form
>>>>>>> staging
end # Migration Controller
