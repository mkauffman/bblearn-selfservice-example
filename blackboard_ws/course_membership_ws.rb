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
        @client.wsdl.document         = CM_DOCUMENT
        @client.wsdl.endpoint         = CM_ENDPOINT
        @client.wsdl.namespace        = CM_SERVICE
		@ses_password                 = session_id
    end

    def message_id
        message_uniq = Time.now.strftime("context_initialize_%m_%d_%Y_%H_%M_%S") 
    end
#Working Method  
    def ws_save_course_membership(op={})
        ses_id   = @ses_password
        response = @client.request :saveCourseMembership do
            wsse.credentials ses_id
            soap.namespaces["xmlns:xsd"] = CM_SERVICE 
            soap.header = { 
                          "wsa:To"          => CM_ENDPOINT, 
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "saveCourseMembership" 
                          }
            soap.input  = ["cour:saveCourseMembership", {"xmlns:cour" => CM_SERVICE}]
            soap.body   =    {
                            "cour:courseId"     => op[:course_id]    || "_375_1",
                            "cour:cmArray"      => {
                                "xsd:available"         =>  op[:available]    || true,
                                "xsd:courseId"          =>  op[:cour]         || "_375_1",
                                #"xsd:dataSourceId"      =>  op[:data_id]      || nil,
                                #"xsd:enrollmentDate"    =>  op[:enroll_date]  || nil,
                                #"xsd:expansionData"     =>  op[:expan_data]   || nil,
                                #"xsd:hasCartridgeAccess"=>  op[:has_cart]     || nil,
                                #"xsd:id"                =>  op[:id]           || nil,
                                #"xsd:imageFile"         =>  op[:image_file]   || nil,
                                #"xsd:roleId"            =>  op[:role_id]      || nil,
                                "xsd:userId"            =>  op[:user_id]      || "_243_1"
                                                    }
                            }
        end
    end

#Working Method
    def ws_initialize_course_membership(op={})
        ses_id   = @ses_password
        response = @client.request :initializeCourseMembershipWS do
            wsse.credentials ses_id
            soap.namespaces["xmlns:cour"] = CM_SERVICE
            soap.header = { 
                          "wsa:To"          => CM_ENDPOINT, 
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "initializeCourseMembershipWS"
                          }
            soap.input  = ["cour:initializeCourseMembershipWS", {"xmlns:cour" => CM_SERVICE}]
            soap.body   = {
                           "cour:ignore"        => op[:ignore] || true
                          }
        end
    end

    def ws_delete_course_membership(op={})
        ses_id   = @ses_password
        response = @client.request :deleteCourseMembership do
            wsse.credentials ses_id
            soap.namespaces["xmlns:cour"] = CM_SERVICE
            soap.header = { 
                          "wsa:To"          => CM_ENDPOINT, 
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "deleteCourseMembership"
                          }
            soap.input  = ["cour:deleteCourseMembership", {"xmlns:cour" => CM_SERVICE}]
            soap.body   = {
                           "cour:courseId"      => op[:course_id]   ||  "_375_1",
                           "cour:ids"           => op[:ids]         ||  "_243_1"
                          }
        end
    end

    def ws_get_course_membership(op={})
        #1 will load GroupMembershipVO records by Id's.
        #2 will load GroupMembershipVO records by course Id's.
        #3 will load GroupMembershipVO records by CourseMembershipVO Id's.
        #4 will load GroupMembershipVO records Group Id's.
        ses_id   = @ses_password
        response = @client.request :getGroupMembership do
            wsse.credentials ses_id
            soap.namespaces["xmlns:xsd"] = CM_SERVICE 
            soap.header = { 
                          "wsa:To"          => CM_ENDPOINT, 
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "getGroupMembership" 
                          }
            soap.input  = ["cour:getGroupMembership", {"xmlns:cour" => CM_SERVICE}]
            soap.body   =    {
                            "cour:courseId"     => op[:course_id]    || "375",
                            "cour:f"            => {
                                #"xsd:courseIds"             =>  op[:course_ids]    || "375_1_",
                                #"xsd:courseMembershipIds"   =>  op[:cour_mem_ids]  || "_635_1",
                                #"xsd:expansionData"         =>  op[:expan_data]    || nil,
                                "xsd:filterType"            =>  op[:filter_type]   || 2,
                                #"xsd:groupIds"              =>  op[:group_ids]     || nil,
                                #"xsd:groupMembershipIds"    =>  op[:grp_mem_ids]   || nil,
                                #"xsd:roleId"                =>  op[:role_id]       || nil,
                                #"xsd:userId"                =>  op[:user_id]       || nil
                                                   }
                            }
        end
    end

end
