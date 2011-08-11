require 'rubygems'
require 'savon'
require 'gyoku'

C_ENDPOINT     = "https://lms-temp.csuchico.edu/webapps/ws/services/Course.WS"
C_DOCUMENT     = "https://lms-temp.csuchico.edu/webapps/ws/services/Course.WS?wsdl"
C_SERVICE      = "http://course.ws.blackboard"

class SectionWS

attr_reader :client, :ses_password

    def initialize(session_id)
        @client                       = Savon::Client.new
        @client.wsdl.document         = C_DOCUMENT
        @client.wsdl.endpoint         = C_ENDPOINT
        @client.wsdl.namespace        = C_SERVICE
		    @ses_password                 = session_id
    end

    def message_id
        message_uniq = Time.now.strftime("context_initialize_%m_%d_%Y_%H_%M_%S")
    end
#Working Method
    def ws_change_course_data_source_id(op={})
        ses_id   = @ses_password
        response = @client.request :changeCourseDataSourceId do
            wsse.credentials ses_id
            soap.namespaces["xmlns:cour"] = C_SERVICE
            soap.header = {
                          "wsa:To"          => C_ENDPOINT,
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "changeCourseDataSourceId"
                          }
            soap.input  = ["user:changeCourseDataSourceId", {"xmlns:cour" => C_SERVICE}]
            soap.body   = {
                          "cour:courseId"           => op[:course_id]   || 324,
                          "cour:newDataSourceId"    => op[:data_id]     || 61
                          }
        end
    end
#Working Method
    def create_course(op={})
        ses_id   = @ses_password
        response = @client.request :createCourse do
            wsse.credentials "session", ses_id
            wsse.created_at               = Time.now.utc
            wsse.expires_at               = Time.now.utc + 60
            soap.namespaces["xmlns:wsa"]  = ADDRESSING
            soap.namespaces["xmlns:xsd"] = C_SERVICE
            soap.header = {
                          "wsa:To"          => C_ENDPOINT,
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "createCourse"
                          }
            soap.input  = ["cour:createCourse", {"xmlns:cour" => C_SERVICE}]
            soap.body   =  {
                            "cour:c" =>   {
                                #"xsd:allowGuests"           => op[:guests]      || nil,
                                #"xsd:allowObservers"        => op[:observers]   || nil,
                                #"xsd:available"             => op[:available]   || nil,
                                #"xsd:batchUid"              => op[:batch_id]    || nil,
                                #"xsd:buttonStyleBbId"       => op[:btn_id]      || nil,
                                #"xsd:buttonStyleShape"      => op[:btn_style]   || nil,
                                #"xsd:buttonStyleType"       => op[:btn_type]    || nil,
                                #"xsd:cartridgeId"           => op[:cart_id]     || nil,
                                #"xsd:classificationId"      => op[:class_id]    || nil,
                                #"xsd:courseDuration"        => op[:duration]    || nil,
                                "xsd:courseId"              => op[:crse_id]     || "thisnewcourse",
                                #"xsd:coursePace"            => op[:crse_pace]   || nil,
                                #"xsd:courseServiceLevel"    => op[:crse_level]  || nil,
                                #"xsd:dataSourceId"          => op[:data_id]     || nil,
                                #"xsd:decAbsoluteLimit"      => op[:limit]       || nil,
                                #"xsd:description"           => op[:desc]        || nil,
                                #"xsd:endDate"               => op[:end_date]    || nil,
                                #"xsd:enrollmentAccessCode"  => op[:access_code] || nil,
                                #"xsd:enrollmentEndDate"     => op[:end_date]    || nil,
                                #"xsd:enrollmentStartDate"   => op[:start_date]  || nil,
                                #"xsd:enrollmentType"        => op[:enroll_type] || nil,
                                #"xsd:expansionData"         => op[:expan_data]  || nil,
                                #"xsd:fee"                   => op[:fee]         || nil,
                                #"xsd:hasDescriptionPage"    => op[:desc_page]   || nil,
                                #"xsd:id"                    => op[:id]          || nil,
                                #"xsd:institutionName"       => op[:inst_name]   || nil,
                                #"xsd:locale"                => op[:locale]      || nil,
                                #"xsd:localeEnforced"        => op[:loc_enf]     || nil,
                                #"xsd:lockedOut"             => op[:locked_out]  || nil,
                                "xsd:name"                  => op[:name]        || "Mwoods Testing Course",
                                #"xsd:navCollapsable"        => op[:nav_cllpe]   || nil,
                                #"xsd:navColorBg"            => op[:nav_clr_bg]  || nil,
                                #"xsd:navColorFg"            => op[:nav_clr_fg]  || nil,
                                #"xsd:navigationStyle"       => op[:nav_style]   || nil,
                                #"xsd:numberOfDaysOfUse"     => op[:num_of_days] || nil,
                                #"xsd:organization"          => op[:org]         || nil,
                                #"xsd:showInCatalog"         => op[:show_in_cat] || nil,
                                #"xsd:softLimit"             => op[:soft_limit]  || nil,
                                #"xsd:startDate"             => op[:start_date]  || nil,
                                #"xsd:uploadLimit"           => op[:upload_lim]  || nil
                                            }
                           }
        end
    end

#Working Method
    def delete_course(op={})
        ses_id   = @ses_password
        response = @client.request :deleteCourse do
            wsse.credentials "session", ses_id
            wsse.created_at               = Time.now.utc
            wsse.expires_at               = Time.now.utc + 60
            soap.namespaces["xmlns:wsa"]  = ADDRESSING
            soap.namespaces["xmlns:cour"]   =  C_SERVICE
            soap.header = {
                          "wsa:To"          => C_ENDPOINT,
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "deleteCourse"
                          }
            soap.input  = ["cour:deleteCourse",
                          {"xmlns:cour"     => C_SERVICE}]
            soap.body   = {"cour:id"        => op[:crsmain_pk1]}
        end
    end

    def ws_get_course(op={})
    #MUST SET FILTER
    #0 - Load all (course|org)
    #1 - Load by courseids and (course|org) flag
    #2 - Load by batchUids and (course|org) flag
    #3 - Load by ids and (course|org) flag
    #4 - Load by categoryids and (course|org) flag
    #5 - Load by searchkey,searchoperator,searchvalue,searchdate,searchdateoperator and (course|org) flag
        ses_id   = @ses_password
        response = @client.request :getCourse do
            wsse.credentials ses_id
            soap.namespaces["xmlns:xsd"]   =  C_SERVICE
            soap.header = {
                          "wsa:To"          => C_ENDPOINT,
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "getCourse"
                          }
            soap.input  = ["cour:getCourse",
                          {"xmlns:cour"     => C_SERVICE}]
            soap.body   = {
                          "cour:filter" =>  {
#                            "xsd:available"                 => op[:available_f] ||  true,
#                            "xsd:batchUids"                 => op[:batch_ids_f] ||  nil,
#                            "xsd:categoryIds"               => op[:cat_ids_f]   ||  nil,
#                            "xsd:courseIds"                 => op[:crse_id_f]   ||  nil,
#                            "xsd:courseTemplates" => {
#                                "xsd:allowGuests"           => op[:guests]      || nil,
#                                "xsd:allowObservers"        => op[:observers]   || nil,
#                                "xsd:available"             => op[:available]   || nil,
#                                "xsd:batchUid"              => op[:batch_id]    || nil,
#                                "xsd:buttonStyleBbId"       => op[:btn_id]      || nil,
#                                "xsd:buttonStyleShape"      => op[:btn_style]   || nil,
#                                "xsd:buttonStyleType"       => op[:btn_type]    || nil,
#                                "xsd:cartridgeId"           => op[:cart_id]     || nil,
#                                "xsd:classificationId"      => op[:class_id]    || nil,
#                                "xsd:courseDuration"        => op[:duration]    || nil,
#                                "xsd:courseId"              => op[:crse_id]     || nil,
#                                "xsd:coursePace"            => op[:crse_pace]   || nil,
#                                "xsd:courseServiceLevel"    => op[:crse_level]  || nil,
#                                "xsd:dataSourceId"          => op[:data_id]     || nil,
#                                "xsd:decAbsoluteLimit"      => op[:limit]       || nil,
#                                "xsd:description"           => op[:desc]        || nil,
#                                "xsd:endDate"               => op[:end_date]    || nil,
#                                "xsd:enrollmentAccessCode"  => op[:access_code] || nil,
#                                "xsd:enrollmentEndDate"     => op[:end_date]    || nil,
#                                "xsd:enrollmentStartDate"   => op[:start_date]  || nil,
#                                "xsd:enrollmentType"        => op[:enroll_type] || nil,
#                                "xsd:expansionData"         => op[:expan_data]  || nil,
#                                "xsd:fee"                   => op[:fee]         || nil,
#                                "xsd:hasDescriptionPage"    => op[:desc_page]   || nil,
#                                "xsd:id"                    => op[:id]          || nil,
#                                "xsd:institutionName"       => op[:inst_name]   || nil,
#                                "xsd:locale"                => op[:locale]      || nil,
#                                "xsd:localeEnforced"        => op[:loc_enf]     || nil,
#                                "xsd:lockedOut"             => op[:locked_out]  || nil,
#                                "xsd:name"                  => op[:name]        || nil,
#                                "xsd:navCollapsable"        => op[:nav_cllpe]   || nil,
#                                "xsd:navColorBg"            => op[:nav_clr_bg]  || nil,
#                                "xsd:navColorFg"            => op[:nav_clr_fg]  || nil,
#                                "xsd:navigationStyle"       => op[:nav_style]   || nil,
#                                "xsd:numberOfDaysOfUse"     => op[:num_of_days] || nil,
#                                "xsd:organization"          => op[:org]         || nil,
#                                "xsd:showInCatalog"         => op[:show_in_cat] || nil,
#                                "xsd:softLimit"             => op[:soft_limit]  || nil,
#                                "xsd:startDate"             => op[:start_date]  || nil,
#                                "xsd:uploadLimit"           => op[:upload_lim]  || nil
#                                                    },
#                            "xsd:dataSourceIds"             => op[:data_id_f]   || nil,
#                            "xsd:expansionData"             => op[:expan_data_f]|| nil,
                            "xsd:filterType"                => op[:filter_type] || 0,
#                            "xsd:ids"                       => op[:ids]         || nil,
#                            "xsd:searchDate"                => op[:search_dte]  || nil,
#                            "xsd:searchDateOperator"        => op[:search_dte_o]|| nil,
#                            "xsd:searchKey"                 => op[:search_key]  || nil,
#                            "xsd:searchOperator"            => op[:search_op]   || nil,
#                            "xsd:searchValue"               => op[:search_val]  || "mwood",
#                            "xsd:sourceBatchUids"           => op[:source_batch]|| nil,
                            "xsd:userIds"                   => op[:user_ids]    || "zoonie",
                                            },
                            }
        end
    end
#Working Method
    def initialize_course(op={})
        ses_id   = @ses_password
        response = @client.request :initializeCourseWS do
            wsse.credentials "session", ses_id
            wsse.created_at               = Time.now.utc
            wsse.expires_at               = Time.now.utc + 60
            soap.namespaces["xmlns:wsa"]  = ADDRESSING
            soap.namespaces["xmlns:cour"] = C_SERVICE
            soap.header = {
                          "wsa:To"          => C_ENDPOINT,
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "initializeCourseWS"
                          }
            soap.input  = ["cour:initializeCourseWS", {"xmlns:cour" => C_SERVICE}]
            soap.body   = {
                           "cour:ignore"        => op[:ignore] || true
                          }
        end
    end

    def save_course(op={})
        ses_id   = @ses_password
        response = @client.request :saveCourse do
            wsse.credentials ses_id
            soap.namespaces["xmlns:xsd"] = C_SERVICE
            soap.header = {
                          "wsa:To"          => C_ENDPOINT,
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "saveCourse"
                          }
            soap.input  = ["cour:saveCourse", {"xmlns:cour" => C_SERVICE}]
            soap.body   = {
                            "cour:c" =>   {
                                "xsd:allowGuests"           => op[:guests]      || nil,
                                "xsd:allowObservers"        => op[:observers]   || nil,
                                "xsd:available"             => op[:available]   || nil,
                                "xsd:batchUid"              => op[:batch_id]    || nil,
                                "xsd:buttonStyleBbId"       => op[:btn_id]      || nil,
                                "xsd:buttonStyleShape"      => op[:btn_style]   || nil,
                                "xsd:buttonStyleType"       => op[:btn_type]    || nil,
                                "xsd:cartridgeId"           => op[:cart_id]     || nil,
                                "xsd:classificationId"      => op[:class_id]    || nil,
                                "xsd:courseDuration"        => op[:duration]    || nil,
                                "xsd:courseId"              => op[:crse_id]     || "test course",
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
                                "xsd:name"                  => op[:name]        || "mwoods Test Class",
                                "xsd:navCollapsable"        => op[:nav_cllpe]   || nil,
                                "xsd:navColorBg"            => op[:nav_clr_bg]  || nil,
                                "xsd:navColorFg"            => op[:nav_clr_fg]  || nil,
                                "xsd:navigationStyle"       => op[:nav_style]   || nil,
                                "xsd:numberOfDaysOfUse"     => op[:num_of_days] || nil,
                                "xsd:organization"          => op[:org]         || nil,
                                "xsd:showInCatalog"         => op[:show_in_cat] || nil,
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
            soap.namespaces["xmlns:cour"] = C_SERVICE
            soap.header = {
                          "wsa:To"          => C_ENDPOINT,
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "updateCourse"
                          }
            soap.input  = ["cour:updateCourse", {"xmlns:cour" => C_SERVICE}]
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

