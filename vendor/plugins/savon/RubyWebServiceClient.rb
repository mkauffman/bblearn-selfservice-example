#!/usr/bin/env ruby
require 'rubygems'
require 'savon'
require 'gyoku'

client = Savon::Client.new do
  wsdl.document = "http://192.168.56.101:80/webapps/ws/services/Context.WS?wsdl"
  wsdl.endpoint = "http://192.168.56.101:80/webapps/ws/services/Context.WS"
  wsdl.namespace = "http://context.ws.blackboard/" 
end




response = client.request :initialize do  
  wsse.credentials "session", "nosession"
  wsse.timestamp = true
  soap.namespaces["xmlns:wsa"] = "http://www.w3.org/2005/08/addressing"
  soap.namespaces["xmlns:wsu"] = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"
  soap.header = { "wsa:To" => "http://192.168.56.101:80/webapps/ws/services/Context.WS", "wsa:MessageID" => "urn:uuid:182F29861349EF02E01251997573947", "wsa:Action" => "initialize" }
end


#puts response.to_xml;
newr = response.to_hash
puts newr[:initialize_response][:return]

