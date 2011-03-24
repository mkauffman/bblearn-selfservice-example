class Person < ActiveRecord::Base
  ########################################### Summary ###############################################
  # Includes                                                                                        #
  # Instance Methods                                                                                #
  # Queries                                                                                         #
  # Object Builder                                                                                  #
  ###################################################################################################
  include Xml_strings # used for creating xml strings
  
  
  ########################################### Instance Methods ######################################
  # Summary of Person Instance Methods:                                                             #
  # add_student                                                                                     #
  # add_primary_instructor                                                                          #
  # add_guest_instructor                                                                            #
  # add_designer                                                                                    #
  # add_teaching_assistant                                                                          #
  # add_auditor                                                                                     #
  # remove_student                                                                                  #
  # remove_instructor                                                                               #
  # remove_designer                                                                                 #
  # update_student                                                                                  #
  # update_instructor                                                                               #
  # update_designer                                                                                 #
  # create_person                                                                                   #
  # update_person                                                                                   #
  # delete_person                                                                                   #
  def add_student(section)
    xml = ""
    xml += Xml_strings.membership_open
    xml += Xml_strings.sourced_id(section)
    xml += Xml_strings.member_open
    xml += Xml_strings.person_sourced_id(self)
    xml += Xml_strings.person_id_type
    xml += Xml_strings.role_add_student(self)
    xml += Xml_strings.member_close
    xml += Xml_strings.membership_close
    
    return xml
  end # add_student
  
  def add_primary_instructor(section)
    xml = ""
    xml += Xml_strings.membership_open
    xml += Xml_strings.sourced_id(section)
    xml += Xml_strings.member_open
    xml += Xml_strings.person_sourced_id(self)
    xml += Xml_strings.person_id_type
    xml += Xml_strings.role_add_primary_instructor(self)
    xml += Xml_strings.member_close
    xml += Xml_strings.membership_close
    
    return xml
  end # add_primary_instructor
  
  def add_guest_instructor(section)
    xml = ""
    xml += Xml_strings.membership_open
    xml += Xml_strings.sourced_id(section)
    xml += Xml_strings.member_open
    xml += Xml_strings.person_sourced_id(self)
    xml += Xml_strings.person_id_type
    xml += Xml_strings.role_add_guest_instructor(self)
    xml += Xml_strings.member_close
    xml += Xml_strings.membership_close
    
    return xml
  end # add_guest_instructor
  
  def add_designer(section)
    xml = ""
    xml += Xml_strings.membership_open
    xml += Xml_strings.sourced_id(section)
    xml += Xml_strings.member_open
    xml += Xml_strings.person_sourced_id(self)
    xml += Xml_strings.person_id_type
    xml += Xml_strings.role_add_designer(self)
    xml += Xml_strings.member_close
    xml += Xml_strings.membership_close
    
    return xml
  end # add_designer
  
  def add_teaching_assistant(section)
    xml = ""
    xml += Xml_strings.membership_open
    xml += Xml_strings.sourced_id(section)
    xml += Xml_strings.member_open
    xml += Xml_strings.person_sourced_id(self)
    xml += Xml_strings.person_id_type
    xml += Xml_strings.role_add_teaching_assistant(self)
    xml += Xml_strings.member_close
    xml += Xml_strings.membership_close
    
    return xml
  end # add_teaching_assistant
  
  def add_auditor(section)
    xml = ""
    xml += Xml_strings.membership_open
    xml += Xml_strings.sourced_id(section)
    xml += Xml_strings.member_open
    xml += Xml_strings.person_sourced_id(self)
    xml += Xml_strings.person_id_type
    xml += Xml_strings.role_add_auditor(self)
    xml += Xml_strings.member_close
    xml += Xml_strings.membership_close
    
    return xml
  end # add_auditor
  
  def remove_student(section)
    xml = ""
    xml += Xml_strings.membership_open
    xml += Xml_strings.sourced_id(section)
    xml += Xml_strings.member_open
    xml += Xml_strings.person_sourced_id(self)
    xml += Xml_strings.person_id_type
    xml += Xml_strings.role_remove_student(self)
    xml += Xml_strings.member_close
    xml += Xml_strings.membership_close
    
    return xml
  end # remove_student
  
  def remove_instructor(section)
    xml = ""
    xml += Xml_strings.membership_open
    xml += Xml_strings.sourced_id(section)
    xml += Xml_strings.member_open
    xml += Xml_strings.person_sourced_id(self)
    xml += Xml_strings.person_id_type
    xml += Xml_strings.role_remove_instructor(self)
    xml += Xml_strings.member_close
    xml += Xml_strings.membership_close
    
    return xml
  end # remove_instructor
  
  def remove_designer(section)
    xml = ""
    xml += Xml_strings.membership_open
    xml += Xml_strings.sourced_id(section)
    xml += Xml_strings.member_open
    xml += Xml_strings.person_sourced_id(self)
    xml += Xml_strings.person_id_type
    xml += Xml_strings.role_remove_designer(self)
    xml += Xml_strings.member_close
    xml += Xml_strings.membership_close
    
    return xml
  end # remove_instructor
  
  def remove_teaching_assistant(section)
    xml = ""
    xml += Xml_strings.membership_open
    xml += Xml_strings.sourced_id(section)
    xml += Xml_strings.member_open
    xml += Xml_strings.person_sourced_id(self)
    xml += Xml_strings.person_id_type
    xml += Xml_strings.role_remove_teaching_assistant(self)
    xml += Xml_strings.member_close
    xml += Xml_strings.membership_close
    
    return xml
  end # remove_teaching_assistant
  
  def remove_auditor(section)
    xml = ""
    xml += Xml_strings.membership_open
    xml += Xml_strings.sourced_id(section)
    xml += Xml_strings.member_open
    xml += Xml_strings.person_sourced_id(self)
    xml += Xml_strings.person_id_type
    xml += Xml_strings.role_remove_auditor(self)
    xml += Xml_strings.member_close
    xml += Xml_strings.membership_close
    
    return xml
  end # remove_auditor
  
  def update_student(section)
    xml = ""
    xml += Xml_strings.membership_open
    xml += Xml_strings.sourced_id(section)
    xml += Xml_strings.member_open
    xml += Xml_strings.person_sourced_id(self)
    xml += Xml_strings.person_id_type
    xml += Xml_strings.role_update_student(self)
    xml += Xml_strings.member_close
    xml += Xml_strings.membership_close
    
    return xml
  end # update_student
  
  def update_instructor(section)
    xml = ""
    xml += Xml_strings.membership_open
    xml += Xml_strings.sourced_id(section)
    xml += Xml_strings.member_open
    xml += Xml_strings.person_sourced_id(self)
    xml += Xml_strings.person_id_type
    xml += Xml_strings.role_update_instructor(self)
    xml += Xml_strings.member_close
    xml += Xml_strings.membership_close
    
    return xml
  end # update_instructor
  
  def update_designer(section)
    xml = ""
    xml += Xml_strings.membership_open
    xml += Xml_strings.sourced_id(section)
    xml += Xml_strings.member_open
    xml += Xml_strings.person_sourced_id(self)
    xml += Xml_strings.person_id_type
    xml += Xml_strings.role_update_designer(self)
    xml += Xml_strings.member_close
    xml += Xml_strings.membership_close
    
    return xml
  end # update_designer
  
  def create_person
    xml = ""
    xml += Xml_strings.person_add_open
    xml += Xml_strings.person_sourced_id(self)
    xml += Xml_strings.user_id(self)
    unless self.first_name.nil? or self.last_name.nil?
      xml += Xml_strings.name(self)
    end # unless first last nil
    xml += Xml_strings.person_close
    
    return xml
  end # create_student
  
  def update_person
    xml = ""
    xml += Xml_strings.person_update_open
    xml += Xml_strings.person_sourced_id(self)
    xml += Xml_strings.user_id(self)
    unless self.first_name.nil? or self.last_name.nil?
      xml += Xml_strings.name(self)
    end # unless first last nil
    xml += Xml_strings.person_close
    
    return xml
  end # update_person
  
  def delete_person
    xml = ""
    xml += Xml_strings.person_delete_open
    xml += Xml_strings.person_sourced_id(self)
    xml += Xml_strings.user_id(self)
    unless self.first_name.nil? or self.last_name.nil?
      xml += Xml_strings.name(self)
    end # unless first last nil
    xml += Xml_strings.person_close
    
    return xml
  end # delete_person
  ########################################### End Instance Methods ##################################
  
  
  ########################################### Queries ###############################################
  # Summary of Person Queries:                                                                      #
  # find_person_by_webct_id                                                                         #
  # find_primary_instructor                                                                         #
  # find_guest_designers_by_section_obj                                                             #
  # find_students                                                                                   #
  # find_teaching_assistants                                                                        #
  # find_auditors                                                                                   #
  # check_user_id_existence                                                                         #
  # check_if_user_is_student_in_section                                                             #
  # check_if_user_is_in_section                                                                     #
  def self.find_person_by_webct_id(webct_id)
    sql = <<__SQL__
      SELECT
        p.remote_userid "sourced_id",
        p.sourcedid_source "source",
        p.id "empl_id",
        p.webct_id "webct_id",
        p.name_fn "full_name",
        p.name_n_family "last_name",
        p.name_n_given "first_name",
        p.name_n_prefix "name_prefix",
        p.name_n_suffix "name_suffix",
        p.name_nickname "nickname",
        p.email "email",
        p.datasource "datasource",
        p.enable_external_mail "is_mail_forwarded",
        p.activestatus "status"
      FROM  webct.person p
      WHERE  webct_id = :webct_id
      AND activestatus = 1  
      AND deletestatus is null 
__SQL__
    
    cursor = $vista_db_conn.parse(sql)
    cursor.bind_param(':webct_id', webct_id)
    cursor.exec
    
    person_ary = build_person_object(cursor)
    return person_ary
  end # find_person_by_webct_id
  
  def self.find_primary_instructor(section_id)
    sql = <<__SQL__
      SELECT
        p.remote_userid "sourced_id",  
        p.sourcedid_source "source",
        p.id "empl_id",
        p.webct_id "webct_id",
        p.name_fn "full_name",
        p.name_n_family "last_name",
        p.name_n_given "first_name",
        p.name_n_prefix "name_prefix",
        p.name_n_suffix "name_suffix",
        p.name_nickname "nickname",
        p.email "email",
        p.datasource "datasource",
        p.enable_external_mail "is_mail_forwarded",
        p.activestatus "status",
        rd.name "role_name", 
        r.primary_flag  "primary_flag"
      FROM
        webct.person p, 
        webct.learning_context lc, 
        webct.role r, 
        webct.role_definition rd, 
        webct.lc_term t, 
        webct.lc_term_mapping tm, 
        webct.member m
      WHERE
        m.status_flag = 1 
        AND m.delete_status = 0 
        AND (rd.name = 'SINS' or rd.name='SDES') 
        AND r.delete_status = 0 
        AND r.member_id = m.id 
        AND r.role_definition_id = rd.id
        AND r.primary_flag = 1 
        AND t.id = tm.lc_term_id 
        AND tm.assigned_lcid = lc.id 
        AND m.learning_context_id = lc.id 
        AND p.id = m.person_id 
        AND p.activestatus = 1 
        AND p.deletestatus is null 
        AND lc.source_id = :section_id
__SQL__
    
    cursor = $vista_db_conn.parse(sql)
    cursor.bind_param(':section_id', section_id)
    cursor.exec
    
    person_ary = build_person_object(cursor)
    return person_ary
  end # self.find_primary_instructor
  
  def self.find_guest_designers_by_section_obj(section)
    sql = <<__SQL__
      SELECT
        p.remote_userid "sourced_id",
        p.sourcedid_source "source",
        p.id "empl_id",
        p.webct_id "webct_id",
        p.name_fn "full_name",
        p.name_n_family "last_name",
        p.name_n_given "first_name",
        p.name_n_prefix "name_prefix",
        p.name_n_suffix "name_suffix",
        p.name_nickname "nickname",
        p.email "email",
        p.datasource "datasource",
        p.enable_external_mail "is_mail_forwarded",
        p.activestatus "status",
        rd.name "role_name", 
        r.primary_flag  "primary_flag"
      FROM
        webct.person p, 
        webct.learning_context lc, 
        webct.role r, 
        webct.role_definition rd, 
        webct.lc_term t, 
        webct.lc_term_mapping tm, 
        webct.member m
      WHERE
        m.status_flag = 1 
        AND m.delete_status = 0 
        AND rd.name='SDES'
        AND r.delete_status = 0 
        AND r.member_id = m.id 
        AND r.role_definition_id = rd.id
        AND r.primary_flag = 0 
        AND t.id = tm.lc_term_id 
        AND tm.assigned_lcid = lc.id 
        AND m.learning_context_id = lc.id 
        AND p.id = m.person_id 
        AND p.activestatus = 1 
        AND p.deletestatus is null 
        AND lc.source_id = :section_id
        AND p.webct_id != :primary_instructor_id
__SQL__
    
    cursor = $vista_db_conn.parse(sql)
    cursor.bind_param(':section_id', section.section_id)
    cursor.bind_param(':primary_instructor_id', section.primary_instructor_id)
    cursor.exec
    
    person_ary = build_person_object(cursor)
    return person_ary
  end # self.find_guest_designers_by_section_id
  
  def self.find_students(section_id)
    sql = <<__SQL__
SELECT
  p.remote_userid "sourced_id",
  p.sourcedid_source "source",
  p.id "empl_id",
  p.webct_id "webct_id",
  p.name_fn "full_name",
  p.name_n_family "last_name",
  p.name_n_given "first_name",
  p.name_n_prefix "name_prefix",
  p.name_n_suffix "name_suffix",
  p.name_nickname "nickname",
  p.email "email",
  p.datasource "datasource",
  p.enable_external_mail "is_mail_forwarded",
  p.activestatus "status",
  rd.name "role_name", 
  r.primary_flag  "primary_flag"
FROM
  webct.member m,
  webct.person p,
  webct.role r,
  webct.role_definition rd
WHERE
  m.person_id = p.id
  and m.id = r.member_id
  and r.role_definition_id = rd.id
  and m.learning_context_id = (select 
    lc.id from webct.learning_context lc 
    where lc.source_id = :section_id and 
    lc.deleted_flag is null)
  and m.delete_status = 0
  and p.webct_id not like 'webct_demo%'
  and rd.name = 'SSTU'
__SQL__
    
    cursor = $vista_db_conn.parse(sql)
    cursor.bind_param(':section_id', section_id)
    cursor.exec
    
    person_ary = build_person_object(cursor)
    return person_ary
  end # self.find_students_by_section_id
  
  def self.find_teaching_assistants(section_id)
    sql = <<__SQL__
SELECT
  p.remote_userid "sourced_id",
  p.sourcedid_source "source",
  p.id "empl_id",
  p.webct_id "webct_id",
  p.name_fn "full_name",
  p.name_n_family "last_name",
  p.name_n_given "first_name",
  p.name_n_prefix "name_prefix",
  p.name_n_suffix "name_suffix",
  p.name_nickname "nickname",
  p.email "email",
  p.datasource "datasource",
  p.enable_external_mail "is_mail_forwarded",
  p.activestatus "status",
  rd.name "role_name", 
  r.primary_flag  "primary_flag"
FROM
  webct.member m,
  webct.person p,
  webct.role r,
  webct.role_definition rd
WHERE
  m.person_id = p.id
  and m.id = r.member_id
  and r.role_definition_id = rd.id
  and m.learning_context_id = (select 
    lc.id from webct.learning_context lc 
    where lc.source_id = :section_id and 
    lc.deleted_flag is null)
  and m.delete_status = 0
  and p.webct_id not like 'webct_demo%'
  and rd.name = 'STEA'
__SQL__

    cursor = $vista_db_conn.parse(sql)
    cursor.bind_param(':section_id', section_id)
    cursor.exec
    
    person_ary = build_person_object(cursor)
    return person_ary
  end # self.find_teaching_assistants
  
  def self.find_auditors(section_id)
    sql = <<__SQL__
SELECT
  p.remote_userid "sourced_id",
  p.sourcedid_source "source",
  p.id "empl_id",
  p.webct_id "webct_id",
  p.name_fn "full_name",
  p.name_n_family "last_name",
  p.name_n_given "first_name",
  p.name_n_prefix "name_prefix",
  p.name_n_suffix "name_suffix",
  p.name_nickname "nickname",
  p.email "email",
  p.datasource "datasource",
  p.enable_external_mail "is_mail_forwarded",
  p.activestatus "status",
  rd.name "role_name", 
  r.primary_flag  "primary_flag"
FROM
  webct.member m,
  webct.person p,
  webct.role r,
  webct.role_definition rd
WHERE
  m.person_id = p.id
  and m.id = r.member_id
  and r.role_definition_id = rd.id
  and m.learning_context_id = (select 
    lc.id from webct.learning_context lc 
    where lc.source_id = :section_id and 
    lc.deleted_flag is null)
  and m.delete_status = 0
  and p.webct_id not like 'webct_demo%'
  and rd.name = 'SAUD'
__SQL__

    cursor = $vista_db_conn.parse(sql)
    cursor.bind_param(':section_id', section_id)
    cursor.exec
    
    person_ary = build_person_object(cursor)
    return person_ary
  end # self.find_auditors
  
  def self.check_user_id_existence(user_id)
    sql = <<__SQL__
SELECT sourcedid_source "source", 
      remote_userid "id", 
      webct_id "userId", 
      name_fn "fullName", 
      name_n_family "familyName", 
      name_n_given "givenName", 
      name_n_prefix "namePrefix", 
      name_n_suffix "name_n_suffix", 
      name_nickname "nickName", 
      email "email", 
      datasource "dataSource", 
      enable_external_mail "isMailBoxForward" 
FROM  webct.person 
WHERE  webct_id = :user_id 
AND activestatus = 1  
AND deletestatus is null 
__SQL__
    
    cursor = $vista_db_conn.parse(sql)
    cursor.bind_param(':user_id', user_id)
    cursor.exec
    
    rs_row = cursor.fetch
    if (rs_row.nil?) 
      return false
    else
      return true
    end # if rs_row
  end # self.check_user_id_existence
  
  def self.check_if_user_is_student_in_section(section_id, user_id)
    sql = <<__SQL__
SELECT 
  p.sourcedid_source "source", 
  p.remote_userid "id", 
  p.webct_id "userId", 
  p.name_fn "fullName", 
  p.name_n_family "familyName", 
  p.name_n_given "givenName", 
  p.name_n_prefix "namePrefix", 
  p.name_n_suffix "name_n_suffix", 
  p.name_nickname "nickName", 
  p.email "email", 
  p.datasource "dataSource", 
  p.enable_external_mail "isMailBoxForward", 
  rd.name "roleName", 
  r.primary_flag  "primaryFlag" 
FROM 
  webct.person p, webct.learning_context lc, 
  webct.role r, webct.role_definition rd, 
  webct.lc_term t, webct.lc_term_mapping tm, webct.member m 
WHERE 
  m.status_flag = 1 
  AND m.delete_status = 0 
  AND ((rd.name = 'SSTU') OR (rd.name = 'SAUD'))
  AND r.delete_status = 0 
  AND r.member_id = m.id 
  AND r.role_definition_id = rd.id 
  AND t.id = tm.lc_term_id 
  AND tm.assigned_lcid = lc.id 
  AND m.learning_context_id = lc.id 
  AND p.id = m.person_id 
  AND p.activestatus = 1 
  AND p.deletestatus is null 
  AND lc.source_id = :section_id 
  AND p.webct_id = :user_id
__SQL__
    
    cursor = $vista_db_conn.parse(sql)
    cursor.bind_param(':section_id', section_id)
    cursor.bind_param(':user_id', user_id)
    cursor.exec
    
    person_ary = build_person_object(cursor)
    unless (person_ary.empty?)
      return true
    else
      return false
    end # unless person_ary
  end # self.check_if_user_is_student_in_section
  
  def self.check_if_user_is_in_section(section_id, user_id)
    sql = <<__SQL__
SELECT 
  p.sourcedid_source "source", 
  p.remote_userid "id", 
  p.webct_id "userId", 
  p.name_fn "fullName", 
  p.name_n_family "familyName", 
  p.name_n_given "givenName", 
  p.name_n_prefix "namePrefix", 
  p.name_n_suffix "name_n_suffix", 
  p.name_nickname "nickName", 
  p.email "email", 
  p.datasource "dataSource", 
  p.enable_external_mail "isMailBoxForward", 
  rd.name "roleName", 
  r.primary_flag  "primaryFlag" 
FROM 
  webct.person p, webct.learning_context lc, 
  webct.role r, webct.role_definition rd, 
  webct.lc_term t, webct.lc_term_mapping tm, webct.member m 
WHERE 
  m.status_flag = 1 
  AND m.delete_status = 0 
  AND r.delete_status = 0 
  AND r.member_id = m.id 
  AND r.role_definition_id = rd.id 
  AND t.id = tm.lc_term_id 
  AND tm.assigned_lcid = lc.id 
  AND m.learning_context_id = lc.id 
  AND p.id = m.person_id 
  AND p.activestatus = 1 
  AND p.deletestatus is null 
  AND lc.source_id = :section_id 
  AND p.webct_id = :user_id
__SQL__
    
    cursor = $vista_db_conn.parse(sql)
    cursor.bind_param(':section_id', section_id)
    cursor.bind_param(':user_id', user_id)
    cursor.exec
    
    person_ary = build_person_object(cursor)
    unless (person_ary.empty?)
      return true
    else
      return false
    end # unless person_ary
  end # check_if_user_is_in_section
  ########################################### End Queries ###########################################
  
  
  ########################################### Object Builder ########################################
  def self.build_person_object(cursor)
    person_ary = Array.new
    while rs_row = cursor.fetch_hash do
      if person_ary.select{|person| person.webct_id == rs_row['webct_id']}.empty?
        person = Person.new
        person.sourced_id = rs_row['sourced_id']
        person.source = rs_row['source']
        person.empl_id = rs_row['empl_id']
        person.webct_id = rs_row['webct_id']
        person.full_name = rs_row['full_name']
        person.last_name = rs_row['last_name']
        person.first_name = rs_row['first_name']
        person.name_prefix = rs_row['name_prefix']
        person.name_suffix = rs_row['name_suffix']
        person.nickname = rs_row['nickname']
        person.email = rs_row['email']
        person.datasource = rs_row['datasource']
        person.is_mail_forwarded = rs_row['is_mail_forwarded']
        person.status = rs_row['status']
        person.role = rs_row['roleName']
        if (rs_row['primaryFlag']==1)
          person.primary = true
        else
          person.primary = false
        end # if rs_row[14]
        person_ary << person
      end # if person_ary
    end # while rs_row
    return person_ary
  end # build_person_object
  ####################################### End Object Builder ########################################
end # class Person