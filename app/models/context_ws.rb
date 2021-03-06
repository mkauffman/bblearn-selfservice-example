require 'rubygems'
require 'savon'
require 'gyoku'

DOMAIN        = "https://#{AppConfig.bbl_ws_domain}/webapps/ws/services/"
ENDPOINT      = DOMAIN + "Context.WS"
DOCUMENT      = DOMAIN + "Context.WS?wsdl"
SERVICE       = "http://context.ws.blackboard"
ADDRESSING    = "http://www.w3.org/2005/08/addressing"
SOAP_TIME     = 3600
EXPECTED_LIFE = 3600


class ContextWS < ActiveResource::Base

attr_reader :client, :ses_password

    def initialize
        @client                       = Savon::Client.new
        @client.wsdl.document         = DOCUMENT
        @client.wsdl.endpoint         = ENDPOINT
        @client.wsdl.namespace        = SERVICE
    end

    def message_id
        message_uniq = Time.now.strftime("context_initialize_%m_%d_%Y_%H_%M_%S")
    end

    def ws
        response = @client.request :initialize do
            wsse.credentials "session", "nosession"
            wsse.created_at               = Time.now.utc
            wsse.expires_at               = Time.now.utc + SOAP_TIME
            soap.namespaces["xmlns:wsa"]  = ADDRESSING
            soap.header = {
                          "wsa:To"          => ENDPOINT,
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "initialize"
                           }
        end
        session_reg = /([^><]+)(?=<\/ns:return>)/
        @ses_password = session_reg.match(response.http.body).to_s
    end

    def login_tool
        ses_id   = @ses_password
        response = @client.request :loginTool do
            wsse.credentials "session", ses_id
            wsse.created_at               = Time.now.utc
            wsse.expires_at               = Time.now.utc + SOAP_TIME
            soap.namespaces["xmlns:wsa"]  = ADDRESSING
            soap.namespaces["xmlns:bbl"]  = SERVICE
            soap.header = {
                          "wsa:To"          => ENDPOINT,
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "loginTool"
                          }
            soap.input  = ["bbl:loginTool", {"xmlns:bbl" => SERVICE}]
            soap.body   = {
                         "bbl:password"             => "#{AppConfig.bbl_tool_pass}",
                         "bbl:clientVendorId"       => "#{AppConfig.bbl_vendor_id}",
                         "bbl:clientProgramId"      => "#{AppConfig.bbl_program_id}",
                         "bbl:loginExtraInfo"       => nil,
                         "bbl:expectedLifeSeconds"  => EXPECTED_LIFE,
                         :order!                    => ["bbl:password",
                                                        "bbl:clientVendorId",
                                                        "bbl:clientProgramId",
                                                        "bbl:loginExtraInfo",
                                                        "bbl:expectedLifeSeconds"
                                                       ]
                          }
        end
    end

    def ws_register_tool
        ses_id   = @ses_password
        response = @client.request :registerTool do
            wsse.credentials "session", ses_id
            wsse.created_at               = Time.now.utc
            wsse.expires_at               = Time.now.utc + SOAP_TIME
            soap.namespaces["xmlns:wsa"]  = ADDRESSING
            soap.namespaces["xmlns:bbl"] = SERVICE
            soap.header = {
                          "wsa:To"          => ENDPOINT,
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "registerTool"
                          }
            soap.input  = ["ns3:registerTool", {"xmlns:ns3" => SERVICE}]
            soap.body = "<ns3:clientVendorId>#{AppConfig.bbl_vendor_id}</ns3:clientVendorId>"
            soap.body += "<ns3:clientProgramId>#{AppConfig.bbl_program_id}</ns3:clientProgramId>"
            soap.body += "<ns3:registrationPassword>#{AppConfig.bbl_tool_registration_password}</ns3:registrationPassword>"
            soap.body += "<ns3:description>Testing tool</ns3:description>"
            soap.body += "<ns3:initialSharedSecret>#{AppConfig.bbl_tool_registration_secret}</ns3:initialSharedSecret>"
            soap.body += "<ns3:requiredToolMethods>Context.WS:getMemberships</ns3:requiredToolMethods>"
            soap.body += "<ns3:requiredToolMethods>Context.WS:emulateUser</ns3:requiredToolMethods>"
            soap.body += "<ns3:requiredToolMethods>Course.WS:initializeCourseWS</ns3:requiredToolMethods>"
            soap.body += "<ns3:requiredToolMethods>Course.WS:createCourse</ns3:requiredToolMethods>"
            soap.body += "<ns3:requiredToolMethods>Course.WS:deleteCourse</ns3:requiredToolMethods>"
            soap.body += "<ns3:requiredToolMethods>Course.WS:saveCourse</ns3:requiredToolMethods>"
            soap.body += "<ns3:requiredToolMethods>Course.WS:updateCourse</ns3:requiredToolMethods>"
            soap.body += "<ns3:requiredToolMethods>Course.WS:saveCourseCategoryMembership</ns3:requiredToolMethods>"
            soap.body += "<ns3:requiredToolMethods>CourseMembership.WS:saveCourseMembership</ns3:requiredToolMethods>"
            soap.body += "<ns3:requiredToolMethods>CourseMembership.WS:updateCourse</ns3:requiredToolMethods>"
            soap.body += "<ns3:requiredToolMethods>CourseMembership.WS:getCourseMembership</ns3:requiredToolMethods>"
            soap.body += "<ns3:requiredToolMethods>User.WS:initializeUserWS</ns3:requiredToolMethods>"
            soap.body += "<ns3:requiredToolMethods>User.WS:getUser</ns3:requiredToolMethods>"
            soap.body += "<ns3:requiredToolMethods>Content.WS:addContentFile</ns3:requiredToolMethods>"
            soap.body += "<ns3:requiredToolMethods>Content.WS:deleteContentFiles</ns3:requiredToolMethods>"
        end
    end

    def ws_login(op={})
        ses_id   = @ses_password
        response = @client.request :login do
            wsse.credentials ses_id
            soap.namespaces["xmlns:bbl"] = SERVICE
            soap.header = {
                          "wsa:To"          => ENDPOINT,
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "login"
                          }
            soap.input  = ["bbl:login", {"xmlns:bbl" => SERVICE}]
            soap.body   = {
                         "bbl:userid"               => op[:user_id]     || "zoonie",
                         "bbl:password"             => op[:password]    || "test123",
                         "bbl:clientVendorId"       => op[:vendor_id]   || "#{AppConfig.bbl_vendor_id}",
                         "bbl:clientProgramId"      => op[:program_id]  || "#{AppConfig.bbl_program_id}",
                         "bbl:loginExtraInfo"       => op[:extra]       || nil,
                         "bbl:expectedLifeSeconds"  => op[:life]        || EXPECTED_LIFE,
                         :order!                    => [
                                                        "bbl:userid",
                                                        "bbl:password",
                                                        "bbl:clientVendorId",
                                                        "bbl:clientProgramId",
                                                        "bbl:loginExtraInfo",
                                                        "bbl:expectedLifeSeconds",
                                                       ]
                          }
        end
    end

    def emulate_user(op={})
        ses_id   = @ses_password
        response = @client.request :emulateUser do
            wsse.credentials "session", ses_id
            wsse.created_at               = Time.now.utc
            wsse.expires_at               = Time.now.utc + SOAP_TIME
            soap.namespaces["xmlns:wsa"]  = ADDRESSING
            soap.namespaces["xmlns:bbl"] = SERVICE
            soap.header = {
                          "wsa:To"          => ENDPOINT,
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "emulateUser"
                          }
            soap.input  = ["bbl:emulateUser", {"xmlns:bbl" => SERVICE}]
            soap.body   = {
			    "bbl:userToEmulate" => op[:user] || "#{AppConfig.bbl_emulate_user}"
                          }
        end
    end

    def ws_deactivate_tool(op={})
        ses_id   = @ses_password
        response = @client.request :deactivateTool do
            wsse.credentials ses_id
            soap.namespaces["xmlns:bbl"] = SERVICE
            soap.header = {
                          "wsa:To"          => ENDPOINT,
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "deactivateTool"
                          }
            soap.input  = ["bbl:deactivateTool", {"xmlns:bbl" => SERVICE}]
            soap.body   = {"bbl:ignore" => op[:ignore] || true}
        end


    end

    def ws_extend_session_life(op={})
        ses_id   = @ses_password
        response = @client.request :emulateUser do
            wsse.credentials ses_id
            soap.namespaces["xmlns:bbl"] = SERVICE
            soap.header = {
                          "wsa:To"          => ENDPOINT,
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "emulateUser"
                          }
            soap.input  = ["bbl:extendSessionLife", {"xmlns:bbl" => SERVICE}]
            soap.body   = {"bbl:addtionalSeconds" => op[:seconds] || EXPECTED_LIFE}
        end
    end
#Working Method
    def ws_get_memberships(op={})
        ses_id   = @ses_password
        response = @client.request :getMemberships do
            wsse.credentials ses_id
            soap.namespaces["xmlns:bbl"] = SERVICE
            soap.header = {
                          "wsa:To"          => ENDPOINT,
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "getMemberships"
                          }
            soap.input  = ["bbl:getMemberships", {"xmlns:bbl" => SERVICE}]
            soap.body   = {"bbl:userid" => op[:userid] || "zoonie"}
        end
    end

    def ws_get_my_memberships(op={})
        ses_id   = @ses_password
        response = @client.request :getMyMemberships do
            wsse.credentials ses_id
            soap.namespaces["xmlns:bbl"] = SERVICE
            soap.header = {
                          "wsa:To"          => ENDPOINT,
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "getMyMemberships"
                          }
        end
    end

    def ws_get_required_entitlements(op={})
        ses_id   = @ses_password
        response = @client.request :getRequiredEntitlements do
            wsse.credentials ses_id
            soap.namespaces["xmlns:bbl"] = SERVICE
            soap.header = {
                          "wsa:To"          => ENDPOINT,
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "getRequiredEntitlements"
                          }
            soap.input  = ["bbl:getRequiredEntitlements", {"xmlns:bbl" => SERVICE}]
            soap.body   = {"bbl:method" => op[:method]}
        end
    end

    def ws_get_server_version(op={})
        ses_id   = @ses_password
        response = @client.request :getServerVersion do
            wsse.credentials ses_id
            soap.namespaces["xmlns:bbl"] = SERVICE
            soap.header = {
                          "wsa:To"          => ENDPOINT,
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "getServerVersion"
                          }
            soap.input  = ["bbl:getServerVersion", {"xmlns:bbl" => SERVICE}]
            soap.body   = {"bbl:method" => {"xsd:version" => op[:version] || nil}}
        end
    end

    def ws_get_system_installation_id(op={})
        ses_id   = @ses_password
        response = @client.request :getSystemInstallationId do
            wsse.credentials ses_id
            soap.namespaces["xmlns:bbl"] = SERVICE
            soap.header = {
                          "wsa:To"          => ENDPOINT,
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "getSystemInstallationId"
                          }
        end
    end

    def ws_initialize_version_2
        response = @client.request :initializeVersion2 do
            wsse.credentials "session", "nosession"
            wsse.created_at               = Time.now.utc
            wsse.expires_at               = Time.now.utc + SOAP_TIME
            soap.namespaces["xmlns:wsa"]  = ADDRESSING
            soap.namespaces["xmlns:bbl"] = SERVICE
            soap.header = {
                          "wsa:To"          => ENDPOINT,
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "initializeVersion2"
                          }
        end
    end

    def ws_login_ticket(op={})
        ses_id   = @ses_password
        response = @client.request :loginTicket do
            wsse.credentials ses_id
            soap.namespaces["xmlns:bbl"] = SERVICE
            soap.header = {
                          "wsa:To"          => ENDPOINT,
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "loginTicket"
                          }
            soap.input  = ["bbl:loginTicket", {"xmlns:bbl" => SERVICE}]
            soap.body   = {
                            "bbl:ticket"                => op[:ticket],
                            "bbl:clientVendorId"        => op[:vendor_id]       || "#{AppConfig.bbl_vendor_id}",
                            "bbl:clientProgramId"       => op[:program_id]      || "#{AppConfig.bbl_program_id}",
                            "bbl:loginExtraInfo"        => op[:extra]           || nil,
                            "bbl:expectedLifeSeconds"   => op[:life_seconds]    || EXPECTED_LIFE
                          }
        end
    end

    def ws_logout(op={})
        ses_id   = @ses_password
        response = @client.request :logout do
            wsse.credentials ses_id
            soap.namespaces["xmlns:bbl"] = SERVICE
            soap.header = {
                          "wsa:To"          => ENDPOINT,
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "logout"
                          }
        end
    end

end

