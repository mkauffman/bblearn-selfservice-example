require 'rubygems'
require 'savon'
require 'gyoku'

DOMAIN          = "https://#{AppConfig.bbl_ws_domain}/webapps/ws/services/"
C_ENDPOINT      = DOMAIN + "Course.WS"
C_DOCUMENT      = DOMAIN + "Course.WS?wsdl"
C_SERVICE       = "http://course.ws.blackboard"

class SectionWS

attr_reader :client, :ses_password

    def initialize(password)
        @client                       = Savon::Client.new
        @client.wsdl.document         = C_DOCUMENT
        @client.wsdl.endpoint         = C_ENDPOINT
        @client.wsdl.namespace        = C_SERVICE
        @ses_password                 = password
    end

    def message_id
        message_uniq = Time.now.strftime("context_initialize_%m_%d_%Y_%H_%M_%S")
    end

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

    def save_course(op={})
        ses_id   = @ses_password
        response = @client.request :saveCourse do
            wsse.credentials "session", ses_id
            wsse.created_at               = Time.now.utc
            wsse.expires_at               = Time.now.utc + SOAP_TIME
            soap.namespaces["xmlns:wsa"]  = ADDRESSING
            soap.namespaces["xmlns:xsd"]  = C_SERVICE
            soap.header = {
                          "wsa:To"          => C_ENDPOINT,
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "saveCourse"
                          }
            soap.input  = ["cour:saveCourse", {"xmlns:cour" => C_SERVICE}]
            soap.body   = {
            "cour:c" =>   {
                "xsd:allowGuests"           => op[:allow_guest_ind]     || nil,
                "xsd:allowObservers"        => op[:allow_observer_ind]  || nil,
                "xsd:available"             => op[:available_ind]       || nil,
                "xsd:batchUid"              => op[:batch_uid]           || nil,
                "xsd:buttonStyleBbId"       => op[:buttonstyles_pk1]    || nil,
                "xsd:buttonStyleShape"      => op[:btn_style_]          || nil,
                "xsd:buttonStyleType"       => op[:btn_type_]           || nil,
                "xsd:cartridgeId"           => op[:cartridge_pk1]       || nil,
                "xsd:classificationId"      => op[:classifications_pk1] || nil,
                "xsd:courseDuration"        => op[:duration]            || nil,
                "xsd:courseId"              => op[:course_id]           || nil,
                "xsd:coursePace"            => op[:pace]                || nil,
                "xsd:courseServiceLevel"    => op[:service_level]       || nil,
                "xsd:dataSourceId"          => op[:data_src_pk1]        || nil,
                #"xsd:decAbsoluteLimit"      => op[:limit_]              || nil,
                "xsd:description"           => op[:course_desc]         || nil,
                #"xsd:endDate"               => op[:end_date_]           || nil,
                #"xsd:enrollmentAccessCode"  => op[:enroll_access_code]  || nil,
                #"xsd:enrollmentEndDate"     => op[:end_date_]           || nil,
                #"xsd:enrollmentStartDate"   => op[:start_date_]         || nil,
                "xsd:enrollmentType"        => op[:enroll_option]       || nil,
                #"xsd:expansionData"         => op[:expan_data_]         || nil,
                #"xsd:fee"                   => op[:fee_]                || nil,
                #"xsd:hasDescriptionPage"    => op[:desc_page_ind]       || nil,
                "xsd:id"                    => op[:pk1]                 || nil,
                "xsd:institutionName"       => op[:institution_name]    || nil,
                "xsd:locale"                => op[:locale]              || nil,
                "xsd:localeEnforced"        => op[:is_locale_enforced]  || nil,
                "xsd:lockedOut"             => op[:lockout_ind]         || nil,
                "xsd:name"                  => op[:course_name]         || nil,
                "xsd:navCollapsable"        => op[:collapsible_ind]     || nil,
                "xsd:navColorBg"            => op[:background_color]    || nil,
                "xsd:navColorFg"            => op[:textcolor]           || nil,
                "xsd:navigationStyle"       => op[:navigation_style]    || nil,
                "xsd:numberOfDaysOfUse"     => op[:days_of_use]         || nil,
                #"xsd:organization"          => op[:org]                 || nil,
                #"xsd:showInCatalog"         => op[:catalog_ind]         || nil,
                #"xsd:softLimit"             => op[:soft_limit_]         || nil,
                #"xsd:startDate"             => op[:start_date_]         || nil,
                #"xsd:uploadLimit"           => op[:upload_lim_]         || nil
                          }
                          }
        end
    end

    def create_course(op={})
        ses_id   = @ses_password
        response = @client.request :createCourse do
            wsse.credentials "session", ses_id
            wsse.created_at               = Time.now.utc
            wsse.expires_at               = Time.now.utc + SOAP_TIME
            soap.namespaces["xmlns:wsa"]  = ADDRESSING
            soap.namespaces["xmlns:xsd"]  = C_SERVICE
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
                                "xsd:available"             => op[:available]   || true,
                                #"xsd:batchUid"              => op[:batch_id]    || nil,
                                #"xsd:buttonStyleBbId"       => op[:btn_id]      || nil,
                                #"xsd:buttonStyleShape"      => op[:btn_style]   || nil,
                                #"xsd:buttonStyleType"       => op[:btn_type]    || nil,
                                #"xsd:cartridgeId"           => op[:cart_id]     || nil,
                                #"xsd:classificationId"      => op[:class_id]    || nil,
                                #"xsd:courseDuration"        => op[:duration]    || nil,
                                "xsd:courseId"              => op[:course_id],
                                #"xsd:coursePace"            => op[:crse_pace]   || nil,
                                #"xsd:courseServiceLevel"    => op[:crse_level]  || nil,
                                "xsd:dataSourceId"          => op[:data_id]     || 41,
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
                                "xsd:name"                  => op[:name],
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
        session_reg = /([^><]+)(?=<\/ns:return>)/
        @ses_password = session_reg.match(response.http.body).to_s
    end

    def delete_course(op={})
        ses_id   = @ses_password
        response = @client.request :deleteCourse do
            wsse.credentials "session", ses_id
            wsse.created_at               = Time.now.utc
            wsse.expires_at               = Time.now.utc + SOAP_TIME
            soap.namespaces["xmlns:wsa"]  = ADDRESSING
            soap.namespaces["xmlns:xsd"]  = C_SERVICE
            soap.header = {
                          "wsa:To"          => C_ENDPOINT,
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "deleteCourse"
                          }
            soap.input  = ["cour:deleteCourse",
                          {"xmlns:cour"     => C_SERVICE}]
            soap.body   = {"cour:id"        => op[:pk1]}
        end
    end

    def ws(op={})
        ses_id   = @ses_password
        response = @client.request :initializeCourseWS do
            wsse.credentials "session", ses_id
            wsse.created_at               = Time.now.utc
            wsse.expires_at               = Time.now.utc + SOAP_TIME
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

######## The following methods are not working:

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
#      HERE                      "xsd:available"             => op[:available]   || nil,
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
#       HERE                     "xsd:showInCatalog"         => op[:show_in_cat] || nil,
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


#If the option is followed by a "_" it means that it is not accessing through
#the options passed in and is to be left.


    def update_course(op={})
        ses_id   = @ses_password
        response = @client.request :updateCourse do
            wsse.credentials "session", ses_id
            wsse.created_at               = Time.now.utc
            wsse.expires_at               = Time.now.utc + SOAP_TIME
            soap.namespaces["xmlns:wsa"]  = ADDRESSING
            soap.namespaces["xmlns:xsd"]  = C_SERVICE
            soap.header = {
                          "wsa:To"          => C_ENDPOINT,
                          "wsa:MessageID"   => message_id,
                          "wsa:Action"      => "updateCourse"
                          }
            soap.input  = ["cour:updateCourse", {"xmlns:cour" => C_SERVICE}]
            soap.body   = {
            "cour:c" =>   {
                "xsd:allowGuests"           => op[:allow_guest_ind]     || nil,
                "xsd:allowObservers"        => op[:allow_observer_ind]  || nil,
                "xsd:available"             => op[:available_ind]       || nil,
                "xsd:batchUid"              => op[:batch_uid]           || nil,
                "xsd:buttonStyleBbId"       => op[:buttonstyles_pk1]    || nil,
                "xsd:buttonStyleShape"      => op[:btn_style_]          || nil,
                "xsd:buttonStyleType"       => op[:btn_type_]           || nil,
                "xsd:cartridgeId"           => op[:cartridge_pk1]       || nil,
                "xsd:classificationId"      => op[:classifications_pk1] || nil,
                "xsd:courseDuration"        => op[:duration]            || 'C',
                "xsd:courseId"              => op[:course_id]           || nil,
                "xsd:coursePace"            => op[:pace]                || 'I',
                "xsd:courseServiceLevel"    => op[:service_level]       || 'F',
                "xsd:dataSourceId"          => op[:data_src_pk1]        || nil,
                #"xsd:decAbsoluteLimit"      => op[:limit_]              || nil,
                "xsd:description"           => op[:course_desc]         || nil,
                #"xsd:endDate"               => op[:end_date_]           || nil,
                #"xsd:enrollmentAccessCode"  => op[:enroll_access_code]  || nil,
                #"xsd:enrollmentEndDate"     => op[:end_date_]           || nil,
                #"xsd:enrollmentStartDate"   => op[:start_date_]         || nil,
                "xsd:enrollmentType"        => op[:enroll_option]       || 'I',
                #"xsd:expansionData"         => op[:expan_data_]         || nil,
                #"xsd:fee"                   => op[:fee_]                || nil,
                #"xsd:hasDescriptionPage"    => op[:desc_page_ind]       || nil,
                "xsd:id"                    => op[:pk1]                 || nil,
                "xsd:institutionName"       => op[:institution_name]    || nil,
                "xsd:locale"                => op[:locale]              || nil,
                "xsd:localeEnforced"        => op[:is_locale_enforced]  || nil,
                "xsd:lockedOut"             => op[:lockout_ind]         || nil,
                "xsd:name"                  => op[:course_name]         || nil,
                "xsd:navCollapsable"        => op[:collapsible_ind]     || nil,
                "xsd:navColorBg"            => op[:background_color]    || nil,
                "xsd:navColorFg"            => op[:textcolor]           || nil,
                "xsd:navigationStyle"       => op[:navigation_style]    || nil,
                "xsd:numberOfDaysOfUse"     => op[:days_of_use]         || nil,
                #"xsd:organization"          => op[:org]                 || nil,
                #"xsd:showInCatalog"         => op[:catalog_ind]         || nil,
                #"xsd:softLimit"             => op[:soft_limit_]         || nil,
                #"xsd:startDate"             => op[:start_date_]         || nil,
                #"xsd:uploadLimit"           => op[:upload_lim_]         || nil
                          }
                          }
        end
    end

end

