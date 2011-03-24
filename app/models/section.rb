class Section < ActiveRecord::Base
  ########################################### Summary ###############################################
  # Includes                                                                                        #
  # Instance Methods                                                                                #
  # Queries                                                                                         #
  # Object Builder                                                                                  #
  ###################################################################################################
  include Xml_strings # used for creating xml strings
  
  
  ########################################### Instance Methods ######################################
  # Summary of Section Instance Methods:                                                            #
  # create_section                                                                                  #
  # create_course                                                                                   #
  # create_xlist_section                                                                            #
  # delete_section                                                                                  #
  # add_member_section                                                                              #
  # remove_member_section                                                                           #
  # update_section                                                                                  #
  # update_xlist_section                                                                            #
  def create_section
    self.level = "90"

    xml = ""
    xml << Xml_strings.group_add_open
    xml << Xml_strings.sourced_id(self)
    xml << Xml_strings.grouptype(self)
    xml << Xml_strings.description(self)
    unless (self.admin_period.nil?): xml << Xml_strings.timeframe(self) end
    xml << Xml_strings.enrollcontrol(self)
    xml << Xml_strings.term_relationship(self)
    xml << Xml_strings.parent_relationship(self)
    xml << Xml_strings.datasource(self)
    unless self.template_parent_id.nil? or self.template_parent_source.nil?
      xml << Xml_strings.extension(self)
    end # unless self
    xml << Xml_strings.group_close

    return xml
  end # create_section
  
  def create_course
    self.level = "80"
    
    xml = ""
    xml << Xml_strings.group_add_open
    xml << Xml_strings.sourced_id(self)
    xml << Xml_strings.grouptype(self)
    xml << Xml_strings.description(self)
    unless (self.admin_period.nil?): xml << Xml_strings.timeframe(self) end
    xml << Xml_strings.enrollcontrol(self)
    xml << Xml_strings.parent_relationship(self)
    xml << Xml_strings.datasource(self)
    xml << Xml_strings.group_close
    
    return xml
  end # create_course
  
  def create_xlist_course
    xml = ""
    
    self.level = "85"
    xml << Xml_strings.group_add_open
    xml << Xml_strings.sourced_id(self)
    xml << Xml_strings.grouptype(self)
    xml << Xml_strings.description(self)
    xml << Xml_strings.extension(self)
    xml << Xml_strings.group_close
    
    return xml
  end # create_xlist_course
  
  def create_xlist_section
    xml = ""
    
    self.level = "90"
    xml << Xml_strings.group_add_open
    xml << Xml_strings.sourced_id(self)
    xml << Xml_strings.grouptype(self)
    xml << Xml_strings.description(self)
    unless (self.admin_period.nil?): xml << Xml_strings.timeframe(self) end
    xml << Xml_strings.term_relationship(self)
    xml << Xml_strings.group_close
    
    return xml
  end # create_xlist_course
  
  def delete_course
    self.level = "80"
    
    xml = ""
    xml << Xml_strings.group_delete_open
    xml << Xml_strings.sourced_id(self)
    xml << Xml_strings.grouptype(self)
    xml << Xml_strings.description(self)
    unless (self.admin_period.nil?): xml << Xml_strings.timeframe(self) end
    xml << Xml_strings.datasource(self)
    xml << Xml_strings.group_close
    
    return xml
  end # delete_course
  
  def delete_section
    self.level = "90"
    
    xml = ""
    xml << Xml_strings.group_delete_open
    xml << Xml_strings.sourced_id(self)
    xml << Xml_strings.grouptype(self)
    xml << Xml_strings.description(self)
    unless (self.admin_period.nil?): xml << Xml_strings.timeframe(self) end
    xml << Xml_strings.datasource(self)
    xml << Xml_strings.group_close
    
    return xml
  end # delete_xlist_section
  
  def add_member_section
    xml = ""
    xml << Xml_strings.membership_open
    xml << Xml_strings.parent_sourced_id(self)
    xml << Xml_strings.member_open
    xml << Xml_strings.sourced_id(self)
    xml << Xml_strings.section_id_type
    xml << Xml_strings.section_add_role
    xml << Xml_strings.member_close
    xml << Xml_strings.membership_close
    
    return xml
  end # add_member_section
  
  def remove_member_section
    xml = ""
    xml << Xml_strings.membership_open
    xml << Xml_strings.parent_sourced_id(self)
    xml << Xml_strings.member_open
    xml << Xml_strings.sourced_id(self)
    xml << Xml_strings.section_id_type
    xml << Xml_strings.section_remove_role
    xml << Xml_strings.member_close
    xml << Xml_strings.membership_close
    
    return xml
  end # remove_member_section
  
  def update_section
    self.level = "90"
    
    xml = ""
    xml << Xml_strings.group_update_open
    xml << Xml_strings.sourced_id(self)
    xml << Xml_strings.grouptype(self)
    xml << Xml_strings.description(self)
    xml << Xml_strings.term_relationship(self)
    xml << Xml_strings.parent_relationship(self)
    xml << Xml_strings.datasource(self)
    xml << Xml_strings.group_close
    
    return xml
  end
  
  def update_xlist_course
    self.level = "85"
    
    xml = ""
    xml << Xml_strings.group_update_open
    xml << Xml_strings.sourced_id(self)
    xml << Xml_strings.grouptype(self)
    xml << Xml_strings.description(self)
    xml << Xml_strings.term_relationship(self)
    xml << Xml_strings.datasource(self)
    xml << Xml_strings.group_close
    
    return xml
  end # update_xlist_section
  ########################################### End Instance Methods ##################################  
  
  
  ########################################### Queries ###############################################
  # Summary of Queries:                                                                             #
  # find_section_by_section_id                                                                      #
  # find_section_by_like_section_id                                                                 #
  # find_course_by_course_id                                                                        #
  # find_sections_by_like_primary_instructor_id_and_term_id                                         #
  # find_sections_by_primary_instructor_id_and_term_id                                              #
  # find_sections_by_primary_instructor_id                                                          #
  # find_sections_by_primary_instructor_for_permission_checking                                     #
  # find_xlisted_sections_children_by_section_obj                                                   #
  # find_xlisted_sections_by_primary_instructor_id_and_term_id                                      #
  # find_non_xlisted_sections_by_primary_instructor_id_and_term_id                                  #
  # find_non_xlisted_sections_by_primary_instructor_id                                              #
  # find_section_enrollment_by_user_id_and_term_id                                                  #  
  def self.find_section_by_section_id(section_id)
    sql = <<__SQL__
      SELECT 
        lc.source_name "source",  
        lc.source_id "section_id",   
        lc.name "short_name",   
        lc.description "long_name",   
        lc.fulldescription "full_name",   
        lc.startdate_time "timeframe_begin",   
        lc.start_restrict "timeframe_restrict_begin",   
        lc.enddate_time "timeframe_end",   
        lc.end_restrict "timeframe_restrict_end",   
        lc.enrollaccept_flag "accept_enrollement",   
        lc.datasource "datasource",   
        lc.adminperiod "admin_period",   
        parent_lc.source_name "parent_source",   
        parent_lc.source_id "parent_id",   
        x.name "term_name",   
        x.source_id "term_id",
        x.datasource "term_datasource",   
        lc.delivery_unit_type "delivery_unit_type",
        lc.id "lc_id",
        y.webct_id "primary_instructor_id",
        y.name_fn "primary_instructor_name"
      FROM   
        webct.learning_context lc   
      JOIN   
        webct.learning_context parent_lc   
          ON parent_lc.id = lc.parent_id   
      JOIN   
        (SELECT 
          tm.assigned_lcid, 
          t.name, 
          t.source_id,
          t.datasource
         FROM 
          webct.lc_term t, 
          webct.lc_term_mapping tm 
         WHERE 
          t.id = tm.lc_term_id) x   
            ON x.assigned_lcid = lc.id
      LEFT OUTER JOIN
        (SELECT 
          m.learning_context_id, 
          m.status_flag, 
          m.delete_status, 
          p.name_fn, 
          p.webct_id 
         FROM 
          webct.person p, 
          webct.member m, 
          webct.role r, 
          webct.role_definition rd 
         WHERE 
          r.role_definition_id = rd.id 
          AND rd.name = 'SINS' 
          AND r.primary_flag = 1 
          AND r.member_id = m.id 
          AND p.id = m.person_id) y
            ON y.learning_context_id = lc.id
            AND y.status_flag = 1
            AND y.delete_status = 0   
      WHERE 
        lc.source_id = :section_id
__SQL__
    
    cursor = $vista_db_conn.parse(sql)
    cursor.bind_param(':section_id', section_id)
    cursor.exec
    
    section_ary = build_section(cursor)
    return section_ary
  end # self.find_section_by_id
  
  def self.find_section_by_like_section_id(section_id)
    sql = <<__SQL__
SELECT 
  lc.source_name "source",  
  lc.source_id "section_id",   
  lc.name "short_name",   
  lc.description "long_name",   
  lc.fulldescription "full_name",   
  lc.startdate_time "timeframe_begin",   
  lc.start_restrict "timeframe_restrict_begin",   
  lc.enddate_time "timeframe_end",   
  lc.end_restrict "timeframe_restrict_end",   
  lc.enrollaccept_flag "accept_enrollement",   
  lc.datasource "datasource",   
  lc.adminperiod "admin_period",   
  parent_lc.source_name "parent_source",   
  parent_lc.source_id "parent_id",   
  x.name "term_name",   
  x.source_id "term_id",
  x.datasource "term_datasource",   
  lc.delivery_unit_type "delivery_unit_type",
  lc.id "lc_id",
  y.webct_id "primary_instructor_id",
  y.name_fn "primary_instructor_name"   
FROM   
  webct.learning_context lc   
JOIN   
  webct.learning_context parent_lc   
    ON parent_lc.id = lc.parent_id   
JOIN   
  (SELECT 
    tm.assigned_lcid, 
    t.name, 
    t.source_id,
    t.datasource 
   FROM 
    webct.lc_term t, 
    webct.lc_term_mapping tm 
   WHERE 
    t.id = tm.lc_term_id) x   
      ON x.assigned_lcid = lc.id
JOIN
  (SELECT 
    m.learning_context_id, 
    m.status_flag, 
    m.delete_status, 
    p.name_fn, 
    p.webct_id 
   FROM 
    webct.person p, 
    webct.member m, 
    webct.role r, 
    webct.role_definition rd 
   WHERE 
    r.role_definition_id = rd.id 
    AND rd.name = 'SINS' 
    AND r.primary_flag = 1 
    AND r.member_id = m.id 
    AND p.id = m.person_id) y
      ON y.learning_context_id = lc.id
      AND y.status_flag = 1
      AND y.delete_status = 0
WHERE 
  lc.source_id LIKE :section_id
  AND (lc.delivery_unit_type = 'XLIST_MASTER' OR lc.delivery_unit_type IS NULL)
  AND rownum < 102     
__SQL__
    
    cursor = $vista_db_conn.parse(sql)
    cursor.bind_param(':section_id', "%"+section_id+"%")
    cursor.exec
    
    section_ary = build_section(cursor)
    return section_ary
  end # self.find_section_by_like_section_id
  
  def self.find_course_by_course_id(course_id)
    sql = <<__SQL__
      SELECT 
        lc.source_name "source",  
        lc.source_id "section_id",   
        lc.name "short_name",   
        lc.description "long_name",   
        lc.fulldescription "full_name",   
        lc.startdate_time "timeframe_begin",   
        lc.start_restrict "timeframe_restrict_begin",   
        lc.enddate_time "timeframe_end",   
        lc.end_restrict "timeframe_restrict_end",   
        lc.enrollaccept_flag "accept_enrollement",   
        lc.datasource "datasource",   
        lc.adminperiod "admin_period",   
        parent_lc.source_name "parent_source",   
        parent_lc.source_id "parent_id",   
        lc.delivery_unit_type "delivery_unit_type",
        lc.id "lc_id"
      FROM   
        webct.learning_context lc   
      JOIN   
        webct.learning_context parent_lc   
          ON parent_lc.id = lc.parent_id  
      WHERE 
        lc.source_id = :course_id
__SQL__
    
    cursor = $vista_db_conn.parse(sql)
    cursor.bind_param(':course_id', course_id)
    cursor.exec
    
    section_ary = build_section(cursor)
    return section_ary
  end # find_course_by_course_id
  
  def self.find_sections_by_like_primary_instructor_id_and_term_id(instructor_id, term_id)
    sql = <<__SQL__
SELECT 
  lc.source_name "source",  
  lc.source_id "section_id",   
  lc.name "short_name",   
  lc.description "long_name",   
  lc.fulldescription "full_name",   
  lc.startdate_time "timeframe_begin",   
  lc.start_restrict "timeframe_restrict_begin",   
  lc.enddate_time "timeframe_end",   
  lc.end_restrict "timeframe_restrict_end",   
  lc.enrollaccept_flag "accept_enrollement",   
  lc.datasource "datasource",   
  lc.adminperiod "admin_period",   
  parent_lc.source_name "parent_source",   
  parent_lc.source_id "parent_id",   
  x.name "term_name",   
  x.source_id "term_id",
  x.datasource "term_datasource",   
  lc.delivery_unit_type "delivery_unit_type",
  lc.id "lc_id",
  y.webct_id "primary_instructor_id",
  y.name_fn "primary_instructor_name" 
FROM 
  webct.learning_context lc 
JOIN 
  webct.learning_context parent_lc 
    ON parent_lc.id = lc.parent_id 
JOIN 
  (SELECT 
    tm.assigned_lcid, 
    t.name, 
    t.source_id,
    t.datasource 
   FROM 
    webct.lc_term t, 
    webct.lc_term_mapping tm 
   WHERE 
    t.id = tm.lc_term_id) x 
      ON x.assigned_lcid = lc.id 
JOIN 
  (SELECT 
    m.learning_context_id, 
    m.status_flag, 
    m.delete_status, 
    p.name_fn, 
    p.webct_id 
   FROM 
    webct.person p, 
    webct.member m, 
    webct.role r, 
    webct.role_definition rd 
   WHERE 
    r.role_definition_id = rd.id 
    AND rd.name = 'SINS' 
    AND r.primary_flag = 1 
    AND r.member_id = m.id 
    AND p.webct_id LIKE :instructor_id 
    AND p.id = m.person_id) y 
      ON y.learning_context_id = lc.id 
        AND y.status_flag = 1 
        AND y.delete_status = 0
        AND x.source_id = :term_id
WHERE
  lc.delivery_unit_type IS NULL or lc.delivery_unit_type = 'XLIST_MASTER'
  AND rownum < 102   
ORDER BY
  lc.source_id DESC
__SQL__
    
    cursor = $vista_db_conn.parse(sql)
    cursor.bind_param(':instructor_id', "%"+instructor_id+"%")
    cursor.bind_param(':term_id', term_id)
    cursor.exec
    
    section_ary = build_section(cursor)
    return section_ary
  end # self.find_sections_by_like_primary_instructor_id_and_term_id
  
  def self.find_sections_by_primary_instructor_id_and_term_id(instructor_id, term_id)
    sql = <<__SQL__
SELECT 
  lc.source_name "source",  
  lc.source_id "section_id",   
  lc.name "short_name",   
  lc.description "long_name",   
  lc.fulldescription "full_name",   
  lc.startdate_time "timeframe_begin",   
  lc.start_restrict "timeframe_restrict_begin",   
  lc.enddate_time "timeframe_end",   
  lc.end_restrict "timeframe_restrict_end",   
  lc.enrollaccept_flag "accept_enrollement",   
  lc.datasource "datasource",   
  lc.adminperiod "admin_period",   
  parent_lc.source_name "parent_source",   
  parent_lc.source_id "parent_id",   
  x.name "term_name",   
  x.source_id "term_id",
  x.datasource "term_datasource",   
  lc.delivery_unit_type "delivery_unit_type",
  lc.id "lc_id",
  y.webct_id "primary_instructor_id",
  y.name_fn "primary_instructor_name" 
FROM 
  webct.learning_context lc 
JOIN 
  webct.learning_context parent_lc 
    ON parent_lc.id = lc.parent_id 
JOIN 
  (SELECT 
    tm.assigned_lcid, 
    t.name, 
    t.source_id,
    t.datasource 
   FROM 
    webct.lc_term t, 
    webct.lc_term_mapping tm 
   WHERE 
    t.id = tm.lc_term_id) x 
      ON x.assigned_lcid = lc.id 
JOIN 
  (SELECT 
    m.learning_context_id, 
    m.status_flag, 
    m.delete_status, 
    p.name_fn, 
    p.webct_id 
   FROM 
    webct.person p, 
    webct.member m, 
    webct.role r, 
    webct.role_definition rd 
   WHERE 
    r.role_definition_id = rd.id 
    AND rd.name = 'SINS' 
    AND r.primary_flag = 1 
    AND r.member_id = m.id 
    AND p.webct_id = :instructor_id 
    AND p.id = m.person_id) y 
      ON y.learning_context_id = lc.id 
        AND y.status_flag = 1 
        AND y.delete_status = 0
        AND x.source_id = :term_id
WHERE
  lc.delivery_unit_type IS NULL or lc.delivery_unit_type = 'XLIST_MASTER'
  AND rownum < 102   
ORDER BY
  x.source_id DESC
__SQL__
    
    cursor = $vista_db_conn.parse(sql)
    cursor.bind_param(':instructor_id', instructor_id)
    cursor.bind_param(':term_id', term_id)
    cursor.exec
    
    section_ary = build_section(cursor)
    return section_ary
  end # self.find_sections_by_primary_instructor_id_and_term_id
  
  def self.find_sections_by_primary_instructor_id(instructor_id)
    sql = <<__SQL__
SELECT 
  lc.source_name "source",  
  lc.source_id "section_id",   
  lc.name "short_name",   
  lc.description "long_name",   
  lc.fulldescription "full_name",   
  lc.startdate_time "timeframe_begin",   
  lc.start_restrict "timeframe_restrict_begin",   
  lc.enddate_time "timeframe_end",   
  lc.end_restrict "timeframe_restrict_end",   
  lc.enrollaccept_flag "accept_enrollement",   
  lc.datasource "datasource",   
  lc.adminperiod "admin_period",   
  parent_lc.source_name "parent_source",   
  parent_lc.source_id "parent_id",   
  x.name "term_name",   
  x.source_id "term_id",
  x.datasource "term_datasource",   
  lc.delivery_unit_type "delivery_unit_type",
  lc.id "lc_id",
  y.webct_id "primary_instructor_id",
  y.name_fn "primary_instructor_name" 
FROM
  webct.learning_context lc
JOIN
  webct.learning_context parent_lc
    ON parent_lc.id = lc.parent_id
JOIN
  (SELECT 
    tm.assigned_lcid, 
    t.name, 
    t.source_id,
    t.datasource 
   FROM 
    webct.lc_term t, 
    webct.lc_term_mapping tm 
   WHERE 
    t.id = tm.lc_term_id) x
      ON x.assigned_lcid = lc.id
JOIN
  (SELECT 
    m.learning_context_id, 
    m.status_flag, 
    m.delete_status,
    p.webct_id,
    p.name_fn  
   FROM 
    webct.person p, 
    webct.member m, 
    webct.role r, 
    webct.role_definition rd 
   WHERE 
    r.role_definition_id = rd.id 
    AND rd.name = 'SINS' 
    AND r.primary_flag = 1 
    AND r.member_id = m.id 
    AND p.webct_id = :instructor_id 
    AND p.id = m.person_id) y
      ON y.learning_context_id = lc.id
      AND y.status_flag = 1
      AND y.delete_status = 0
WHERE
  lc.delivery_unit_type IS NULL or lc.delivery_unit_type = 'XLIST_MASTER'
ORDER BY
  x.source_id DESC
__SQL__
    
    cursor = $vista_db_conn.parse(sql)
    cursor.bind_param(':instructor_id', instructor_id)
    cursor.exec
    
    section_ary = build_section(cursor)
    return section_ary
  end # self.find_sections_by_primary_instructor_id
  
  def self.find_sections_by_primary_instructor_for_permission_checking(instructor_id)
    sql = <<__SQL__
SELECT 
  lc.source_name "source",  
  lc.source_id "section_id",   
  lc.name "short_name",   
  lc.description "long_name",   
  lc.fulldescription "full_name",   
  lc.startdate_time "timeframe_begin",   
  lc.start_restrict "timeframe_restrict_begin",   
  lc.enddate_time "timeframe_end",   
  lc.end_restrict "timeframe_restrict_end",   
  lc.enrollaccept_flag "accept_enrollement",   
  lc.datasource "datasource",   
  lc.adminperiod "admin_period",   
  parent_lc.source_name "parent_source",   
  parent_lc.source_id "parent_id",   
  x.name "term_name",   
  x.source_id "term_id",
  x.datasource "term_datasource",   
  lc.delivery_unit_type "delivery_unit_type",
  lc.id "lc_id",
  y.webct_id "primary_instructor_id",
  y.name_fn "primary_instructor_name" 
FROM
  webct.learning_context lc
JOIN
  webct.learning_context parent_lc
    ON parent_lc.id = lc.parent_id
JOIN
  (SELECT 
    tm.assigned_lcid, 
    t.name, 
    t.source_id,
    t.datasource 
   FROM 
    webct.lc_term t, 
    webct.lc_term_mapping tm 
   WHERE 
    t.id = tm.lc_term_id) x
      ON x.assigned_lcid = lc.id
JOIN
  (SELECT 
    m.learning_context_id, 
    m.status_flag, 
    m.delete_status,
    p.webct_id,
    p.name_fn  
   FROM 
    webct.person p, 
    webct.member m, 
    webct.role r, 
    webct.role_definition rd 
   WHERE 
    r.role_definition_id = rd.id 
    AND rd.name = 'SINS' 
    AND r.primary_flag = 1 
    AND r.member_id = m.id 
    AND p.webct_id = :instructor_id 
    AND p.id = m.person_id) y
      ON y.learning_context_id = lc.id
      AND y.status_flag = 1
      AND y.delete_status = 0
ORDER BY
  lc.source_id DESC
__SQL__
    
    cursor = $vista_db_conn.parse(sql)
    cursor.bind_param(':instructor_id', instructor_id)
    cursor.exec
    
    section_ary = build_section(cursor)
    return section_ary
  end # find_sections_by_primary_instructor_for_permission_checking
  
  def self.find_xlisted_sections_children_by_section_obj(section)
    sql = <<__SQL__
SELECT 
  lc.source_name "source",  
  lc.source_id "section_id",   
  lc.name "short_name",   
  lc.description "long_name",   
  lc.fulldescription "full_name",   
  lc.startdate_time "timeframe_begin",   
  lc.start_restrict "timeframe_restrict_begin",   
  lc.enddate_time "timeframe_end",   
  lc.end_restrict "timeframe_restrict_end",   
  lc.enrollaccept_flag "accept_enrollement",   
  lc.datasource "datasource",   
  lc.adminperiod "admin_period",   
  parent_lc.source_name "parent_source",   
  parent_lc.source_id "parent_id",   
  x.name "term_name",   
  x.source_id "term_id",
  x.datasource "term_datasource",   
  lc.delivery_unit_type "delivery_unit_type",
  lc.id "lc_id",
  y.webct_id "primary_instructor_id",
  y.name_fn "primary_instructor_name" 
FROM
  webct.learning_context lc
JOIN
  webct.learning_context parent_lc
    ON parent_lc.id = lc.parent_id
JOIN
  (SELECT 
    tm.assigned_lcid, 
    t.name, 
    t.source_id,
    t.datasource 
   FROM 
    webct.lc_term t, 
    webct.lc_term_mapping tm 
   WHERE 
    t.id = tm.lc_term_id) x
      ON x.assigned_lcid = lc.id
JOIN
  (SELECT 
    m.learning_context_id, 
    m.status_flag, 
    m.delete_status,
    p.webct_id,
    p.name_fn
   FROM 
    webct.person p, 
    webct.member m, 
    webct.role r, 
    webct.role_definition rd 
   WHERE 
    r.role_definition_id = rd.id 
    AND rd.name = 'SINS' 
    AND r.primary_flag = 1 
    AND r.member_id = m.id 
    AND p.id = m.person_id) y
      ON y.learning_context_id = lc.id
      AND y.status_flag = 1
      AND y.delete_status = 0
JOIN
  (SELECT 
    xlist.child_lcid 
   FROM 
    webct.xlist_lc_mapping xlist 
   WHERE 
    xlist.master_lcid = :lc_id) z
      ON z.child_lcid = lc.id
__SQL__
    
    cursor = $vista_db_conn.parse(sql)
    cursor.bind_param(':lc_id', section.lc_id)
    cursor.exec
    
    section_ary = build_section(cursor)
    return section_ary
  end # self.find_xlisted_sections_children_by_lc_id
  
  def self.find_xlisted_sections_by_primary_instructor_id_and_term_id(instructor_id, term_id)
    sql = <<__SQL__
SELECT 
  lc.source_name "source",  
  lc.source_id "section_id",   
  lc.name "short_name",   
  lc.description "long_name",   
  lc.fulldescription "full_name",   
  lc.startdate_time "timeframe_begin",   
  lc.start_restrict "timeframe_restrict_begin",   
  lc.enddate_time "timeframe_end",   
  lc.end_restrict "timeframe_restrict_end",   
  lc.enrollaccept_flag "accept_enrollement",   
  lc.datasource "datasource",   
  lc.adminperiod "admin_period",   
  parent_lc.source_name "parent_source",   
  parent_lc.source_id "parent_id",   
  x.name "term_name",   
  x.source_id "term_id",
  x.datasource "term_datasource",   
  lc.delivery_unit_type "delivery_unit_type",
  lc.id "lc_id",
  y.webct_id "primary_instructor_id",
  y.name_fn "primary_instructor_name" 
FROM
  webct.learning_context lc
JOIN
  webct.learning_context parent_lc
    ON parent_lc.id = lc.parent_id
JOIN
  (SELECT 
    tm.assigned_lcid, 
    t.name, 
    t.source_id, 
    t.datasource 
   FROM 
    webct.lc_term t, 
    webct.lc_term_mapping tm 
   WHERE 
    t.id = tm.lc_term_id) x
      ON x.assigned_lcid = lc.id
JOIN
  (SELECT 
    m.learning_context_id, 
    m.status_flag, 
    m.delete_status,
    p.webct_id,
    p.name_fn
   FROM 
    webct.person p, 
    webct.member m, 
    webct.role r, 
    webct.role_definition rd 
   WHERE 
    r.role_definition_id = rd.id 
    AND rd.name = 'SINS' 
    AND r.primary_flag = 1 
    AND r.member_id = m.id 
    AND p.webct_id = :instructor_id 
    AND p.id = m.person_id) y
      ON y.learning_context_id = lc.id
      AND y.status_flag = 1
      AND y.delete_status = 0
      AND lc.source_id LIKE 'xlist%'
      AND lc.adminperiod = :term_id
WHERE
  lc.delivery_unit_type IS NULL or lc.delivery_unit_type = 'XLIST_MASTER'
__SQL__
    
    cursor = $vista_db_conn.parse(sql)
    cursor.bind_param(':instructor_id', instructor_id)
    cursor.bind_param(':term_id', term_id)
    cursor.exec
    
    section_ary = build_section(cursor)
    return section_ary
  end # self.find_xlisted_sections_by_primary_instructor_id_and_term_id
  
  def self.find_non_xlisted_sections_by_primary_instructor_id_and_term_id(instructor_id, term_id)
    sql = <<__SQL__
SELECT 
  lc.source_name "source",  
  lc.source_id "section_id",   
  lc.name "short_name",   
  lc.description "long_name",   
  lc.fulldescription "full_name",   
  lc.startdate_time "timeframe_begin",   
  lc.start_restrict "timeframe_restrict_begin",   
  lc.enddate_time "timeframe_end",   
  lc.end_restrict "timeframe_restrict_end",   
  lc.enrollaccept_flag "accept_enrollement",   
  lc.datasource "datasource",   
  lc.adminperiod "admin_period",   
  parent_lc.source_name "parent_source",   
  parent_lc.source_id "parent_id",   
  x.name "term_name",   
  x.source_id "term_id",
  x.datasource "term_datasource",   
  lc.delivery_unit_type "delivery_unit_type",
  lc.id "lc_id",
  y.webct_id "primary_instructor_id",
  y.name_fn "primary_instructor_name" 
FROM 
  webct.learning_context lc 
JOIN 
  webct.learning_context parent_lc 
    ON parent_lc.id = lc.parent_id 
JOIN 
  (SELECT 
    tm.assigned_lcid, 
    t.name, 
    t.source_id,
    t.datasource 
   FROM 
    webct.lc_term t, 
    webct.lc_term_mapping tm 
   WHERE 
    t.id = tm.lc_term_id) x 
      ON x.assigned_lcid = lc.id 
JOIN 
  (SELECT m.learning_context_id, 
    m.status_flag, 
    m.delete_status,
    p.webct_id,
    p.name_fn
   FROM 
    webct.person p, 
    webct.member m, 
    webct.role r, 
    webct.role_definition rd 
   WHERE 
    r.role_definition_id = rd.id 
    AND rd.name = 'SINS' 
    AND r.primary_flag = 1 
    AND r.member_id = m.id 
    AND p.webct_id = :instructor_id 
    AND p.id = m.person_id) y 
      ON y.learning_context_id = lc.id 
      AND y.status_flag = 1 
      AND y.delete_status = 0
      AND lc.source_id NOT LIKE 'xlist%'
      AND x.source_id = :term_id
WHERE
  lc.delivery_unit_type IS NULL or lc.delivery_unit_type = 'XLIST_MASTER'
ORDER BY
  x.source_id DESC
__SQL__
    
    cursor = $vista_db_conn.parse(sql)
    cursor.bind_param(':instructor_id', instructor_id)
    cursor.bind_param(':term_id', term_id)
    cursor.exec
    
    section_ary = build_section(cursor)
    return section_ary
  end # self.ind_non_xlisted_sections_by_primary_instructor_id_and_term_id
  
  def self.find_non_xlisted_sections_by_primary_instructor_id(instructor_id)
    sql = <<__SQL__
SELECT 
  lc.source_name "source",  
  lc.source_id "section_id",   
  lc.name "short_name",   
  lc.description "long_name",   
  lc.fulldescription "full_name",   
  lc.startdate_time "timeframe_begin",   
  lc.start_restrict "timeframe_restrict_begin",   
  lc.enddate_time "timeframe_end",   
  lc.end_restrict "timeframe_restrict_end",   
  lc.enrollaccept_flag "accept_enrollement",   
  lc.datasource "datasource",   
  lc.adminperiod "admin_period",   
  parent_lc.source_name "parent_source",   
  parent_lc.source_id "parent_id",   
  x.name "term_name",   
  x.source_id "term_id",
  x.datasource "term_datasource",   
  lc.delivery_unit_type "delivery_unit_type",
  lc.id "lc_id",
  y.webct_id "primary_instructor_id",
  y.name_fn "primary_instructor_name" 
FROM
  webct.learning_context lc
JOIN
  webct.learning_context parent_lc
    ON parent_lc.id = lc.parent_id
JOIN
  (SELECT 
    tm.assigned_lcid, 
    t.name, 
    t.source_id, 
    t.datasource 
   FROM 
    webct.lc_term t, 
    webct.lc_term_mapping tm 
   WHERE 
    t.id = tm.lc_term_id) x
      ON x.assigned_lcid = lc.id
JOIN
  (SELECT 
    m.learning_context_id, 
    m.status_flag, 
    m.delete_status,
    p.webct_id,
    p.name_fn
   FROM 
    webct.person p, 
    webct.member m, 
    webct.role r, 
    webct.role_definition rd 
   WHERE 
    r.role_definition_id = rd.id 
    AND rd.name = 'SINS' 
    AND r.primary_flag = 1 
    AND r.member_id = m.id 
    AND p.webct_id = :instructor_id 
    AND p.id = m.person_id) y
      ON y.learning_context_id = lc.id
      AND y.status_flag = 1
      AND y.delete_status = 0
      AND lc.source_id NOT LIKE 'xlist%'
WHERE
  lc.delivery_unit_type IS NULL or lc.delivery_unit_type = 'XLIST_MASTER'
__SQL__
    
    cursor = $vista_db_conn.parse(sql)
    cursor.bind_param(':instructor_id', instructor_id)
    cursor.exec
    
    section_ary = build_section(cursor)
    return section_ary
  end # self.find_non_xlisted_sections_by_primary_instructor_id
  
  def self.find_section_enrollment_by_user_id_and_term_id(user_id, term_id)
    sql = <<__SQL__
SELECT 
  lc.source_name "source",  
  lc.source_id "section_id",   
  lc.name "short_name",   
  lc.description "long_name",   
  lc.fulldescription "full_name",   
  lc.startdate_time "timeframe_begin",   
  lc.start_restrict "timeframe_restrict_begin",   
  lc.enddate_time "timeframe_end",   
  lc.end_restrict "timeframe_restrict_end",   
  lc.enrollaccept_flag "accept_enrollement",   
  lc.datasource "datasource",   
  lc.adminperiod "admin_period",   
  parent_lc.source_name "parent_source",   
  parent_lc.source_id "parent_id",   
  x.name "term_name",   
  x.source_id "term_id",
  x.datasource "term_datasource",   
  lc.delivery_unit_type "delivery_unit_type",
  lc.id "lc_id",
  y.webct_id "primary_instructor_id",
  y.name_fn "primary_instructor_name" 
FROM 
  webct.learning_context lc 
JOIN 
  webct.learning_context parent_lc 
    ON parent_lc.id = lc.parent_id 
JOIN 
  (SELECT 
    tm.assigned_lcid, 
    t.name, 
    t.source_id,
    t.datasource 
   FROM 
    webct.lc_term t, 
    webct.lc_term_mapping tm 
   WHERE 
    t.id = tm.lc_term_id) x 
      ON x.assigned_lcid = lc.id 
JOIN 
  (SELECT 
    m.learning_context_id, 
    m.status_flag, 
    m.delete_status,
    p.webct_id,
    p.name_fn
   FROM 
    webct.person p, 
    webct.member m, 
    webct.role r, 
    webct.role_definition rd 
   WHERE 
    r.role_definition_id = rd.id 
    AND r.member_id = m.id 
    AND p.webct_id = :user_id 
    AND p.id = m.person_id) y 
      ON y.learning_context_id = lc.id 
      AND y.status_flag = 1 
      AND y.delete_status = 0
      AND x.source_id = :term_id
WHERE
  lc.delivery_unit_type IS NULL or lc.delivery_unit_type = 'XLIST_MASTER'
ORDER BY
  x.source_id DESC
__SQL__
    
    cursor = $vista_db_conn.parse(sql)
    cursor.bind_param(':user_id', user_id)
    cursor.bind_param(':term_id', term_id)
    cursor.exec
    
    section_ary = build_section(cursor)
    return section_ary
  end # self.find_section_enrollment_by_user_id_and_term_id
  ######################################## End Queries ###############################################
  
  
  
  ######################################## Object Builder ############################################
  def self.build_section(cursor)
    section_ary = Array.new
    while rs_row = cursor.fetch_hash do
      if section_ary.select{|section| section.section_id == rs_row['section_id']}.empty?
        section = Section.new
        section.source = rs_row['source']
        section.lc_id = rs_row['lc_id']
        section.section_id = rs_row['section_id']
        section.short_name = rs_row['short_name']
        unless rs_row['long_name'].nil?: section.long_name = rs_row['long_name'].read end
        unless rs_row['full_name'].nil?: section.full_name = rs_row['full_name'].read end
        section.timeframe_begin = rs_row['timeframe_begin']
        section.timeframe_restrict_begin = rs_row['timeframe_restrict_begin']
        section.timeframe_end = rs_row['timeframe_end']
        section.timeframe_restrict_end = rs_row['timeframe_restrict_end']
        section.accept_enrollment = rs_row['accept_enrollment']
        section.datasource = rs_row['datasource']
        section.parent_source = rs_row['parent_source']
        section.parent_id = rs_row['parent_id']
        section.template_parent_id = rs_row['template_parent_id']
        section.template_parent_source = rs_row['template_parent_source']
        section.template_zip_or_epk_path = rs_row['template_zip_or_epk_path']
        section.template_none = rs_row['template_none']
        section.delivery_unit_type = rs_row['delivery_unit_type']
        section.term_name = rs_row['term_name']
        section.term_id = rs_row['term_id']
        section.admin_period = rs_row['admin_period']
        section.parent_id = rs_row['parent_id']
        section.term_datasource = rs_row['term_datasource']
        section.admin_xlist_sect_type = rs_row['admin_xlist_sect_type']
        section.primary_instructor_id = rs_row['primary_instructor_id']
        section.primary_instructor_name = rs_row['primary_instructor_name']
        
        timeframe_begin = section.timeframe_begin.to_s[0,10].to_i
        timeframe_end = section.timeframe_end.to_s[0,10].to_i
        unless (timeframe_begin == 0) 
          section.timeframe_begin = Time.at(timeframe_begin).strftime("%Y-%m-%d") 
        else
          section.timeframe_begin = nil
        end # unless timeframe begin
        unless (timeframe_end == 0) 
          section.timeframe_end = Time.at(timeframe_end).strftime("%Y-%m-%d") 
        else
          section.timeframe_end = nil
        end # unless timeframe end
        if (section.short_name.nil?): section.short_name = "" end
        if (section.long_name.nil?): section.long_name = "" end
        if (section.full_name.nil?): section.full_name = "" end
        if (section.timeframe_restrict_begin.nil?)
          section.timeframe_restrict_begin = "0" 
        else
          section.timeframe_restrict_begin = "1"  
        end # if timeframe begin
        if (section.timeframe_restrict_end.nil?) 
          section.timeframe_restrict_end = "0" 
        else
          section.timeframe_restrict_end = "1"
        end # if timeframe end
        if (section.accept_enrollment.nil?)
          section.accept_enrollment = "0"
        else
          section.accept_enrollment = "1"
        end # if accept_enrollment
        section_ary << section
      end # if section_ary
    end # while rs_row
    return section_ary
  end # build_section
  #################################### End Object Builder ############################################
end # class Section