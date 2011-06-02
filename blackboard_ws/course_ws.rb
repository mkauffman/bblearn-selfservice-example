require 'rubygems'
require 'savon'
require 'gyoku'

C_ENDPOINT     = "https://lms-temp.csuchico.edu/webapps/ws/services/Course.WS"
C_DOCUMENT     = "https://lms-temp.csuchico.edu/webapps/ws/services/Course.WS?wsdl"
C_SERVICE      = "http://course.ws.blackboard"

class CourseWS

attr_reader :client, :ses_password

    def initialize(session_id)
        @client                       = Savon::Client.new
        @client.wsdl.document         = DOCUMENT
        @client.wsdl.endpoint         = ENDPOINT
        @client.wsdl.namespace        = SERVICE
		@ses_password = session_id
    end

    def ws_change_course_data_source_id(op={})
        ses_id   = @ses_password
        response = @client.request :changeCourseDataSourceId do
            wsse.credentials ses_id
            soap.namespaces["xmlns:cour"] = SERVICE
            soap.header = { 
                          "wsa:To"          => ENDPOINT, 
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "changeCourseDataSourceId"
                          }
            soap.input  = ["user:changeCourseDataSourceId", {"xmlns:cour" => SERVICE}]
            soap.body   = {
                          "cour:courseId"           => op[:course_id],
                          "cour:newDataSourceId"    => op[:data_id]
                          }
        end
    end

    def ws_create_course(op={})
        ses_id   = @ses_password
        response = @client.request :createCourse do
            wsse.credentials ses_id
            soap.namespaces["xmlns:cour"] = SERVICE
            soap.header = { 
                          "wsa:To"          => ENDPOINT, 
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "createCourse"
                          }
            soap.input  = ["cour:createCourse", {"xmlns:cour" => SERVICE}]
            soap.body   =  {        
                            "cour:c" =>   {
                                "xsd:allowGuests"           => op[:guests]      || true,
                                "xsd:allowObservers"        => op[:observers]   || true,
                                "xsd:available"             => op[:available]   || true,
                                "xsd:batchUid"              => op[:batch_id]    || nil,
                                "xsd:buttonStyleBbId"       => op[:btn_id]      || nil,
                                "xsd:buttonStyleShape"      => op[:btn_style]   || nil,
                                "xsd:buttonStyleType"       => op[:btn_type]    || nil,
                                "xsd:cartridgeId"           => op[:cart_id]     || nil,
                                "xsd:classificationId"      => op[:class_id]    || nil,
                                "xsd:courseDuration"        => op[:duration]    || nil,
                                "xsd:courseId"              => op[:crse_id]     || nil,
                                "xsd:coursePace"            => op[:crse_pace]   || nil,
                                "xsd:courseServiceLevel"    => op[:crse_level]  || nil,
                                "xsd:dataSourceId"          => op[:data_id]     || nil,
                                "xsd:decAbsoluteLimit"      => op[:limit]       || nil,
                                "xsd:description"           => op[:desc]        || nil,
                                "xsd:endDate"               => op[:end_date]    || nil,
                                "xsd:enrollmentAccessCode"  => op[:access_code] || nil,
                                "xsd:enrollmentEndDate"     => op[:end_date]    || nil,
                                "xsd:enrollmentStartDate"   => op[:start_date]  || nil,
                                "xsd:enrollmentType"        => op[:enroll_type] || nil,
                                "xsd:expansionData"         => op[:expan_data]  || nil,
                                "xsd:fee"                   => op[:fee]         || nil,
                                "xsd:hasDescriptionPage"    => op[:desc_page]   || nil,
                                "xsd:id"                    => op[:id]          || nil,
                                "xsd:institutionName"       => op[:inst_name]   || nil,
                                "xsd:locale"                => op[:locale]      || nil,
                                "xsd:localeEnforced"        => op[:loc_enf]     || nil,
                                "xsd:lockedOut"             => op[:locked_out]  || nil,
                                "xsd:name"                  => op[:name]        || nil,
                                "xsd:navCollapsable"        => op[:nav_cllpe]   || nil,
                                "xsd:navColorBg"            => op[:nav_clr_bg]  || nil,
                                "xsd:navColorFg"            => op[:nav_clr_fg]  || nil,
                                "xsd:navigationStyle"       => op[:nav_style]   || nil,
                                "xsd:numberOfDaysOfUse"     => op[:num_of_days] || nil,
                                "xsd:organization"          => op[:org]         || nil,
                                "xsd:showInCatalog"         => op[:show_in_cat] || true,
                                "xsd:softLimit"             => op[:soft_limit]  || nil,
                                "xsd:startDate"             => op[:start_date]  || nil,
                                "xsd:uploadLimit"           => op[:upload_lim]  || nil
                                            }
                           }
        end
    end

    def ws_delete_course(op={})
        ses_id   = @ses_password
        response = @client.request :deleteCourse do
            wsse.credentials ses_id
            soap.namespaces["xmlns:cour"]   =  SERVICE
            soap.header = { 
                          "wsa:To"          => ENDPOINT, 
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "deleteCourse"
                          }
            soap.input  = ["cour:deleteCourse", 
                          {"xmlns:cour"     => SERVICE}]
            soap.body   = {"cour:id"        => op[:id]}
        end
    end

    def ws_get_course(op={})
        ses_id   = @ses_password
        response = @client.request :getCourse do
            wsse.credentials ses_id
            soap.namespaces["xmlns:cour"]   =  SERVICE
            soap.header = { 
                          "wsa:To"          => ENDPOINT, 
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "getCourse"
                          }
            soap.input  = ["cour:getCourse", 
                          {"xmlns:cour"     => SERVICE}]
            soap.body   = { 
                          "cour:filter" =>  {
                            "xsd:available"                 => op[:available_f]   ||  true,
                            "xsd:batchUids"                 => op[:batch_ids_f]   ||  nil,   
                            "xsd:categoryIds"               => op[:cat_ids_f]     ||  nil,
                            "xsd:courseIds"                 => op[:crse_id_f]   ||  nil,
                            "xsd:courseTemplates" => {
                                "xsd:allowGuests"           => op[:guests]      || true,
                                "xsd:allowObservers"        => op[:observers]   || true,
                                "xsd:available"             => op[:available]   || true,
                                "xsd:batchUid"              => op[:batch_id]    || nil,
                                "xsd:buttonStyleBbId"       => op[:btn_id]      || nil,
                                "xsd:buttonStyleShape"      => op[:btn_style]   || nil,
                                "xsd:buttonStyleType"       => op[:btn_type]    || nil,
                                "xsd:cartridgeId"           => op[:cart_id]     || nil,
                                "xsd:classificationId"      => op[:class_id]    || nil,
                                "xsd:courseDuration"        => op[:duration]    || nil,
                                "xsd:courseId"              => op[:crse_id]     || nil,
                                "xsd:coursePace"            => op[:crse_pace]   || nil,
                                "xsd:courseServiceLevel"    => op[:crse_level]  || nil,
                                "xsd:dataSourceId"          => op[:data_id]     || nil,
                                "xsd:decAbsoluteLimit"      => op[:limit]       || nil,
                                "xsd:description"           => op[:desc]        || nil,
                                "xsd:endDate"               => op[:end_date]    || nil,
                                "xsd:enrollmentAccessCode"  => op[:access_code] || nil,
                                "xsd:enrollmentEndDate"     => op[:end_date]    || nil,
                                "xsd:enrollmentStartDate"   => op[:start_date]  || nil,
                                "xsd:enrollmentType"        => op[:enroll_type] || nil,
                                "xsd:expansionData"         => op[:expan_data]  || nil,
                                "xsd:fee"                   => op[:fee]         || nil,
                                "xsd:hasDescriptionPage"    => op[:desc_page]   || nil,
                                "xsd:id"                    => op[:id]          || nil,
                                "xsd:institutionName"       => op[:inst_name]   || nil,
                                "xsd:locale"                => op[:locale]      || nil,
                                "xsd:localeEnforced"        => op[:loc_enf]     || nil,
                                "xsd:lockedOut"             => op[:locked_out]  || nil,
                                "xsd:name"                  => op[:name]        || nil,
                                "xsd:navCollapsable"        => op[:nav_cllpe]   || nil,
                                "xsd:navColorBg"            => op[:nav_clr_bg]  || nil,
                                "xsd:navColorFg"            => op[:nav_clr_fg]  || nil,
                                "xsd:navigationStyle"       => op[:nav_style]   || nil,
                                "xsd:numberOfDaysOfUse"     => op[:num_of_days] || nil,
                                "xsd:organization"          => op[:org]         || nil,
                                "xsd:showInCatalog"         => op[:show_in_cat] || true,
                                "xsd:softLimit"             => op[:soft_limit]  || nil,
                                "xsd:startDate"             => op[:start_date]  || nil,
                                "xsd:uploadLimit"           => op[:upload_lim]  || nil
                                                    },
                            "xsd:dataSourceIds"             => op[:data_id_f]   || nil,
                            "xsd:expansionData"             => op[:expan_data_f]|| nil,
                            "xsd:filterType"                => op[:filter_type] || 2,
                            "xsd:ids"                       => op[:ids]         || nil,
                            "xsd:searchDate"                => op[:search_dte]  || nil,
                            "xsd:searchDateOperator"        => op[:search_dte_o]|| nil,
                            "xsd:searchKey"                 => op[:search_key]  || nil,
                            "xsd:searchOperator"            => op[:search_op]   || nil,
                            "xsd:searchValue"               => op[:search_val]  || nil,
                            "xsd:sourceBatchUids"           => op[:source_batch]|| nil,
                            "xsd:userIds"                   => op[:user_ids]    || nil,
                                            },
                            }
        end
    end

    def ws_initialize_course(op={})
        ses_id   = @ses_password
        response = @client.request :initializeCourseWS do
            wsse.credentials ses_id
            soap.namespaces["xmlns:cour"] = SERVICE
            soap.header = { 
                          "wsa:To"          => ENDPOINT, 
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "initializeCourseWS"
                          }
            soap.input  = ["cour:initializeCourseWS", {"xmlns:cour" => SERVICE}]
            soap.body   = {
                           "cour:ignore"        => op[:ignore] || true
                          }
        end
    end

    def ws_save_course(op={})
        ses_id   = @ses_password
        response = @client.request :saveCourse do
            wsse.credentials ses_id
            soap.namespaces["xmlns:cour"] = SERVICE
            soap.header = { 
                          "wsa:To"          => ENDPOINT, 
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "saveCourse"
                          }
            soap.input  = ["cour:saveCourse", {"xmlns:cour" => SERVICE}]
            soap.body   = {
                            "cour:c" =>   {
                                "xsd:allowGuests"           => op[:guests]      || true,
                                "xsd:allowObservers"        => op[:observers]   || true,
                                "xsd:available"             => op[:available]   || true,
                                "xsd:batchUid"              => op[:batch_id]    || nil,
                                "xsd:buttonStyleBbId"       => op[:btn_id]      || nil,
                                "xsd:buttonStyleShape"      => op[:btn_style]   || nil,
                                "xsd:buttonStyleType"       => op[:btn_type]    || nil,
                                "xsd:cartridgeId"           => op[:cart_id]     || nil,
                                "xsd:classificationId"      => op[:class_id]    || nil,
                                "xsd:courseDuration"        => op[:duration]    || nil,
                                "xsd:courseId"              => op[:crse_id]     || nil,
                                "xsd:coursePace"            => op[:crse_pace]   || nil,
                                "xsd:courseServiceLevel"    => op[:crse_level]  || nil,
                                "xsd:dataSourceId"          => op[:data_id]     || nil,
                                "xsd:decAbsoluteLimit"      => op[:limit]       || nil,
                                "xsd:description"           => op[:desc]        || nil,
                                "xsd:endDate"               => op[:end_date]    || nil,
                                "xsd:enrollmentAccessCode"  => op[:access_code] || nil,
                                "xsd:enrollmentEndDate"     => op[:end_date]    || nil,
                                "xsd:enrollmentStartDate"   => op[:start_date]  || nil,
                                "xsd:enrollmentType"        => op[:enroll_type] || nil,
                                "xsd:expansionData"         => op[:expan_data]  || nil,
                                "xsd:fee"                   => op[:fee]         || nil,
                                "xsd:hasDescriptionPage"    => op[:desc_page]   || nil,
                                "xsd:id"                    => op[:id]          || nil,
                                "xsd:institutionName"       => op[:inst_name]   || nil,
                                "xsd:locale"                => op[:locale]      || nil,
                                "xsd:localeEnforced"        => op[:loc_enf]     || nil,
                                "xsd:lockedOut"             => op[:locked_out]  || nil,
                                "xsd:name"                  => op[:name]        || nil,
                                "xsd:navCollapsable"        => op[:nav_cllpe]   || nil,
                                "xsd:navColorBg"            => op[:nav_clr_bg]  || nil,
                                "xsd:navColorFg"            => op[:nav_clr_fg]  || nil,
                                "xsd:navigationStyle"       => op[:nav_style]   || nil,
                                "xsd:numberOfDaysOfUse"     => op[:num_of_days] || nil,
                                "xsd:organization"          => op[:org]         || nil,
                                "xsd:showInCatalog"         => op[:show_in_cat] || true,
                                "xsd:softLimit"             => op[:soft_limit]  || nil,
                                "xsd:startDate"             => op[:start_date]  || nil,
                                "xsd:uploadLimit"           => op[:upload_lim]  || nil
                                            }
                        }
        end
    end

    def ws_update_course(op={})
        ses_id   = @ses_password
        response = @client.request :updateCourse do
            wsse.credentials ses_id
            soap.namespaces["xmlns:cour"] = SERVICE
            soap.header = { 
                          "wsa:To"          => ENDPOINT, 
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "updateCourse"
                          }
            soap.input  = ["cour:updateCourse", {"xmlns:cour" => SERVICE}]
            soap.body   =  {
                            "cour:c" =>   {
                                "xsd:allowGuests"           => op[:guests]      || true,
                                "xsd:allowObservers"        => op[:observers]   || true,
                                "xsd:available"             => op[:available]   || true,
                                "xsd:batchUid"              => op[:batch_id]    || nil,
                                "xsd:buttonStyleBbId"       => op[:btn_id]      || nil,
                                "xsd:buttonStyleShape"      => op[:btn_style]   || nil,
                                "xsd:buttonStyleType"       => op[:btn_type]    || nil,
                                "xsd:cartridgeId"           => op[:cart_id]     || nil,
                                "xsd:classificationId"      => op[:class_id]    || nil,
                                "xsd:courseDuration"        => op[:duration]    || nil,
                                "xsd:courseId"              => op[:crse_id]     || nil,
                                "xsd:coursePace"            => op[:crse_pace]   || nil,
                                "xsd:courseServiceLevel"    => op[:crse_level]  || nil,
                                "xsd:dataSourceId"          => op[:data_id]     || nil,
                                "xsd:decAbsoluteLimit"      => op[:limit]       || nil,
                                "xsd:description"           => op[:desc]        || nil,
                                "xsd:endDate"               => op[:end_date]    || nil,
                                "xsd:enrollmentAccessCode"  => op[:access_code] || nil,
                                "xsd:enrollmentEndDate"     => op[:end_date]    || nil,
                                "xsd:enrollmentStartDate"   => op[:start_date]  || nil,
                                "xsd:enrollmentType"        => op[:enroll_type] || nil,
                                "xsd:expansionData"         => op[:expan_data]  || nil,
                                "xsd:fee"                   => op[:fee]         || nil,
                                "xsd:hasDescriptionPage"    => op[:desc_page]   || nil,
                                "xsd:id"                    => op[:id]          || nil,
                                "xsd:institutionName"       => op[:inst_name]   || nil,
                                "xsd:locale"                => op[:locale]      || nil,
                                "xsd:localeEnforced"        => op[:loc_enf]     || nil,
                                "xsd:lockedOut"             => op[:locked_out]  || nil,
                                "xsd:name"                  => op[:name]        || nil,
                                "xsd:navCollapsable"        => op[:nav_cllpe]   || nil,
                                "xsd:navColorBg"            => op[:nav_clr_bg]  || nil,
                                "xsd:navColorFg"            => op[:nav_clr_fg]  || nil,
                                "xsd:navigationStyle"       => op[:nav_style]   || nil,
                                "xsd:numberOfDaysOfUse"     => op[:num_of_days] || nil,
                                "xsd:organization"          => op[:org]         || nil,
                                "xsd:showInCatalog"         => op[:show_in_cat] || true,
                                "xsd:softLimit"             => op[:soft_limit]  || nil,
                                "xsd:startDate"             => op[:start_date]  || nil,
                                "xsd:uploadLimit"           => op[:upload_lim]  || nil
                                        }
                            }
        end
    end

end
