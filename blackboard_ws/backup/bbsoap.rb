require 'rubygems'
require 'savon'
require 'gyoku'

CONTEXT_END     = "https://lms-temp.csuchico.edu/webapps/ws/services/Context.WS"
CONTEXT_DOC     = "https://lms-temp.csuchico.edu/webapps/ws/services/Context.WS?wsdl"
CONTEXT_NAME    = "http://context.ws.blackboard"

USER_END     = "https://lms-temp.csuchico.edu/webapps/ws/services/User.WS"
USER_DOC     = "https://lms-temp.csuchico.edu/webapps/ws/services/User.WS?wsdl"
USER_NAME    = "http://user.ws.blackboard"

CM_END     = "https://lms-temp.csuchico.edu/webapps/ws/services/CourseMembership.WS"
CM_DOC     = "https://lms-temp.csuchico.edu/webapps/ws/services/CourseMembership.WS?wsdl"
CM_NAME    = "http://coursemembership.ws.blackboard"

class BbSoap

attr_reader :client, :ses_password, :user_client

    def initialize
        @client                       = Savon::Client.new
        @client.wsdl.document         = CONTEXT_DOC
        @client.wsdl.endpoint         = CONTEXT_END
        @client.wsdl.namespace        = CONTEXT_NAME

        @user_client                  = Savon::Client.new
        @user_client.wsdl.document    = USER_DOC
        @user_client.wsdl.endpoint    = USER_END
        @user_client.wsdl.namespace   = USER_NAME

        @cm_client                    = Savon::Client.new
        @cm_client.wsdl.document      = CM_DOC
        @cm_client.wsdl.endpoint      = CM_END
        @cm_client.wsdl.namespace     = CM_NAME

    end
    
    def message_id
        message_uniq = Time.now.strftime("context_initialize_%m_%d_%Y_%H_%M_%S") 
    end
    
    def ws_save_course_membership(op={})
        ses_id   = @ses_password
        response = @cm_client.request :saveCourseMembership do
            wsse.credentials "session", ses_id
            wsse.created_at = created
            wsse.expires_at = expires

            soap.namespaces["xmlns:wsa"] = "http://www.w3.org/2005/08/addressing"
            soap.namespaces["xmlns:wsu"] = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"
            soap.namespaces["xmlns:xsd"] = CM_NAME 
            soap.header = { 
                          "wsa:To"          => CM_END, 
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "saveCourseMembership" 
                          }
            soap.input  = ["cour:saveCourseMembership", {"xmlns:cour" => CM_NAME}]
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
end
