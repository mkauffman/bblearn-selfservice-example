require 'rubygems'
require 'savon'
require 'gyoku'

U_ENDPOINT     = "https://lms-temp.csuchico.edu/webapps/ws/services/User.WS"
U_DOCUMENT     = "https://lms-temp.csuchico.edu/webapps/ws/services/User.WS?wsdl"
U_SERVICE      = "http://user.ws.blackboard"


class UserWS

attr_reader :client, :ses_password

    def initialize(session_id)
        @client                       = Savon::Client.new
        @client.wsdl.document         = DOCUMENT
        @client.wsdl.endpoint         = ENDPOINT
        @client.wsdl.namespace        = SERVICE
		@ses_password = session_id
    end

    def message_id
        message_uniq = Time.now.strftime("context_initialize_%m_%d_%Y_%H_%M_%S") 
    end

    def ws_user_initialize(op={})
        ses_id   = @ses_password
        response = @client.request :initializeUserWS do
            wsse.credentials ses_id
            soap.namespaces["xmlns:user"] = SERVICE
            soap.header = { 
                          "wsa:To"          => ENDPOINT, 
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "initializeUserWS"
                          }
            soap.input = ["user:initializeUserWS", {"xmlns:user" => SERVICE}]
            soap.body   = {
                         "user:ignore"  => op[:ignore] || true 
                          }
        end
        session_reg = /([^><]+)(?=<\/ns:return>)/
        initialize_resp = session_reg.match(response.http.body).to_s
    end

    def ws_delete_user(op={})
        ses_id   = @ses_password
        response = @client.request :deleteUser do
            wsse.credentials ses_id
            soap.namespaces["xmlns:user"] = SERVICE
            soap.header = { 
                          "wsa:To"          => ENDPOINT, 
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "deleteUser"
                          }
            soap.input = ["user:deleteUser", {"xmlns:user" => SERVICE}]
            soap.body   =  {
                            "user:userId"   => op[:id] || "_216_1"
                           }
        end
        session_reg = /([^><]+)(?=<\/ns:return>)/
        delete_user_resp = session_reg.match(response.http.body).to_s
    end

    def ws_get_user(op={})
        ses_id   = @ses_password
        response = @client.request :getUser do
            wsse.credentials ses_id
            soap.namespaces["xmlns:user"] = SERVICE
            soap.header = { 
                          "wsa:To"          => ENDPOINT, 
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "getUser"
                          }
            soap.input = ["user:getUser", {"xmlns:user" => SERVICE}]
            soap.body   =  {
                #MUST SET filterType to 1-7
                #1 - GET_ALL_USERS_WITH_AVAILABILITY
                #2 - GET_USER_BY_ID_WITH_AVAILABILITY
                #3 - GET_USER_BY_BATCH_ID_WITH_AVAILABILITY
                #4 - GET_USER_BY_COURSE_ID_WITH_AVAILABILITY
                #5 - GET_USER_BY_GROUP_ID_WITH_AVAILABILITY
                #6 - GET_USER_BY_NAME_WITH_AVAILABILITY
                #7 - GET_USER_BY_SYSTEM_ROLE
                            "user:filter"   =>  {
                               "xsd:available"      => op[:available]   || true,
                               "xsd:batchId"        => op[:batch_id]    || nil,
                               "xsd:courseId"       => op[:course_id]   || nil,
                               "xsd:expansionData"  => op[:expan_data]  || nil,
                               "xsd:filterType"     => op[:filter]      || 2,
                               "xsd:groupId"        => op[:group_id]    || nil,
                               "xsd:id"             => op[:id]          || nil,
                               "xsd:name"           => op[:name]        || nil,
                               "xsd:systemRoles"    => op[:sys_roles]   || nil,
                                                }
                           }
        end
        session_reg = /([^><]+)(?=<\/ns:return>)/
        users = response.http.body.scan(session_reg)
    end

    def ws_get_system_roles(op={})
        ses_id   = @ses_password
        response = @client.request :getSystemRoles do
            wsse.credentials ses_id
            soap.namespaces["xmlns:user"] = SERVICE 
            soap.header = { 
                          "wsa:To"          => ENDPOINT, 
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "getSystemRoles" 
                          }
            soap.input  = ["user:getSystemRoles", {"xmlns:user" => SERVICE}]
            soap.body   = {
                         "user:filter" => op[:filter] || nil 
                          }
        end
    end

    def ws_save_user(op={})
        ses_id   = @ses_password
        response = @user_client.request :saveUser do
            wsse.credentials ses_id
            soap.namespaces["xmlns:xsd"] = SERVICE 
            soap.header = { 
                          "wsa:To"          => ENDPOINT, 
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "saveUser" 
                          }
            soap.input  = ["user:saveUser", {"xmlns:user" => SERVICE}]
            soap.body   = {"user:user"   => {
                            "xsd:birthDate"         =>  op[:bdate]      || nil,
                            "xsd:dataSourceId"      =>  op[:data_id]    || 61,
                            "xsd:educationLevel"    =>  op[:edu_level]  || "UNKNOWN", 
                            "xsd:expansionData"     =>  op[:edata]      || nil,
                            "xsd:extendedInfo"      =>  {
                                "xsd:businessFax"       => op[:bfax]        || nil,
                                "xsd:businessPhone1"    => op[:bphone1]     || nil,
                                "xsd:businessPhone2"    => op[:bphone2]     || nil,
                                "xsd:city"              => op[:city]        || nil,
                                "xsd:company"           => op[:company]     || nil,
                                "xsd:country"           => op[:country]     || nil,
                                "xsd:department"        => op[:dept]        || nil,
                                "xsd:emailAddress"      => op[:email]       || nil,
                                "xsd:expansionData"     => op[:edata]       || nil, 
                                "xsd:familyName"        => op[:fam_name]    || "testin",
                                "xsd:givenName"         => op[:given_name]  || "testin",
                                "xsd:homeFax"           => op[:hfax]        || nil,
                                "xsd:homePhone1"        => op[:hphone1]     || nil,
                                "xsd:homePhone2"        => op[:hphone2]     || nil,
                                "xsd:jobTitle"          => op[:jtitle]      || nil,
                                "xsd:middleName"        => op[:mname]       || "test",
                                "xsd:mobilePhone"       => op[:mphone]      || nil,
                                "xsd:state"             => op[:state]       || nil,
                                "xsd:street1"           => op[:street1]     || nil,
                                "xsd:street2"           => op[:street2]     || nil,
                                "xsd:webPage"           => op[:wpage]       || nil,
                                "xsd:zipCode"           => op[:zip]         || nil,
                                                        },
                            "xsd:genderType"        => op[:gender]      || "MALE",
                            "xsd:id"                => op[:id]          || nil,
                            "xsd:insRoles"          => op[:ins_roles]   || nil,
                            "xsd:isAvailable"       => op[:available]   || true,
                            "xsd:name"              => op[:name]        || "zest",
                            "xsd:password"          => op[:password]    || "test123",
                            "xsd:studentId"         => op[:student_id]  || "testin",
                            "xsd:systemRoles"       => op[:sys_roles]   || nil, 
                            "xsd:title"             => op[:title]       || nil,
                            "xsd:userBatchUid"      => op[:batch_uid]   || nil,
                                             }
                            }
                end
    end

end
