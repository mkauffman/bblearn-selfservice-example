require 'rubygems'
require 'savon'
require 'gyoku'

CM_ENDPOINT     = "https://lms-temp.csuchico.edu/webapps/ws/services/CourseMembership.WS"
CM_DOCUMENT     = "https://lms-temp.csuchico.edu/webapps/ws/services/CourseMembership.WS?wsdl"
CM_SERVICE      = "http://coursemembership.ws.blackboard"

class CourseMembershipWS

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
    
    def ws_save_course_membership(op={})
        ses_id   = @ses_password
        response = @client.request :saveCourseMembership do
            wsse.credentials ses_id
            soap.namespaces["xmlns:xsd"] = SERVICE 
            soap.header = { 
                          "wsa:To"          => ENDPOINT, 
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "saveCourseMembership" 
                          }
            soap.input  = ["cour:saveCourseMembership", {"xmlns:cour" => SERVICE}]
            soap.body   =    {
                            "cour:courseId"     => op[:course_id]    || nil,
                            "cour:cmArray"      => {
                                "xsd:available"         =>  op[:available]    || nil,
                                "xsd:cour"              =>  op[:cour]         || nil,
                                "xsd:dataSourceId"      =>  op[:data_id]      || nil,
                                "xsd:enrollmentDate"    =>  op[:enroll_date]  || nil,
                                "xsd:expansionData"     =>  op[:expan_data]   || nil,
                                "xsd:hasCartridgeAccess"=>  op[:has_cart]     || nil,
                                "xsd:id"                =>  op[:id]           || nil,
                                "xsd:imageFile"         =>  op[:image_file]   || nil,
                                "xsd:roleId"            =>  op[:role_id]      || nil,
                                "xsd:userId"            =>  op[:user_id]      || nil
                                                    }
                            }
        end
    end

    def ws_initialize_course_membership_ws(op={})
        ses_id   = @ses_password
        response = @client.request :initializeCourseMembershipWS do
            wsse.credentials ses_id
            soap.namespaces["xmlns:cour"] = SERVICE
            soap.header = { 
                          "wsa:To"          => ENDPOINT, 
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "initializeCourseMembershipWS"
                          }
            soap.input  = ["cour:initializeCourseMembershipWS", {"xmlns:cour" => SERVICE}]
            soap.body   = {
                           "cour:ignore"        => op[:ignore] || true
                          }
        end
    end

    def ws_delete_course_membership(op={})
        ses_id   = @ses_password
        response = @client.request :deleteCourseMembership do
            wsse.credentials ses_id
            soap.namespaces["xmlns:cour"] = SERVICE
            soap.header = { 
                          "wsa:To"          => ENDPOINT, 
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "deleteCourseMembership"
                          }
            soap.input  = ["cour:deleteCourseMembership", {"xmlns:cour" => SERVICE}]
            soap.body   = {
                           "cour:courseId"      => op[:course_id],
                           "cour:ids"           => op[:ids]
                          }
        end
    end

    def ws_get_course_membership(op={})
        ses_id   = @ses_password
        response = @client.request :getGroupMembership do
            wsse.credentials ses_id
            soap.namespaces["xmlns:xsd"] = SERVICE 
            soap.header = { 
                          "wsa:To"          => ENDPOINT, 
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "getGroupMembership" 
                          }
            soap.input  = ["cour:getGroupMembership", {"xmlns:cour" => SERVICE}]
            soap.body   =    {
                            "cour:courseId"     => op[:course_id]    || nil,
                            "cour:f"            => {
                                "xsd:courseIds"             =>  op[:course_ids]    || nil,
                                "xsd:courseMembershipIds"   =>  op[:cour_mem_ids]  || nil,
                                "xsd:expansionData"         =>  op[:expan_data]    || nil,
                                "xsd:filterType"            =>  op[:filter_type]   || nil,
                                "xsd:groupIds"              =>  op[:group_ids]     || nil,
                                "xsd:groupMembershipIds"    =>  op[:grp_mem_ids]   || nil,
                                "xsd:roleId"                =>  op[:role_id]       || nil,
                                "xsd:userId"                =>  op[:user_id]       || nil
                                                    }
                            }
        end
    end

end
