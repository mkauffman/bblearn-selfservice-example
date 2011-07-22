class Section < ActiveRecord::Base
  attr_accessor :id, :source, :lc_id, :section_id, :short_name,
   :long_name, :full_name, :timeframe_begin, :timeframe_restrict_begin,
   :timeframe_end, :timeframe_restrict_end, :accept_enrollment, :datasource,
   :parent_source, :parent_id, :template_parent_id, :template_parent_source,
   :template_zip_or_epk_path, :template_none, :delivery_unit_type, :term_name,
   :term_id, :admin_period, :term_datasource, :primary_instructor_name,
   :primary_instructor_id, :admin_xlist_sect_type, :level, :created_at,
   :updated_at, :student_list_file_name, :student_list_content_type,
   :student_list_file_size, :student_list_updated_at, :status

  def self.find_by_user(user_id)
    sql = <<__SQL__
    SELECT csm.COURSE_NAME
    FROM dbTable.COURSE_MAIN csm
    JOIN (SELECT csu.CRSMAIN_PK1
          FROM dbTable.COURSE_USERS csu
          JOIN (SELECT PK1
                FROM dbTable.USERS
                WHERE USER_ID = :user_id) usr
          ON csu.USERS_PK1 = usr.PK1) crs
    ON csm.PK1 = crs.CRSMAIN_PK1
__SQL__


    cursor = Section.build_cursor(sql)
    cursor.bind_param(':user_id', user_id)

    #logger.info ' *** The user \''+user_id+'\' is in the following courses: '+courses.join(",")
    return Section.build_section(cursor)
  end


  def self.find_by_user_and_role(user_id,role_name)
    sql = <<__SQL__
    SELECT csm.COURSE_NAME
    FROM dbTable.COURSE_MAIN csm
    JOIN (SELECT csu.CRSMAIN_PK1
          FROM dbTable.COURSE_USERS csu
          JOIN (SELECT PK1
                FROM dbTable.USERS
                WHERE USER_ID = :user_id) usr
          ON csu.USERS_PK1 = usr.PK1
          WHERE csu.ROLE = :role_name) crs
    ON csm.PK1 = crs.CRSMAIN_PK1
__SQL__

    cursor = Section.build_cursor(sql)
    cursor.bind_param(':user_id', user_id)
    cursor.bind_param(':role_name', role_name)

    #logger.info ' *** The user \''+user_id+'\' is in the following courses with role \''+role_name+'\': '+courses.join(",")
    return Section.build_section(cursor)
  end


  def self.build_cursor(sql)
    # Substitute values into query and execute:
    $bbl_db_table = AppConfig.bbl_db_table
    sql = sql.gsub!("dbTable",$bbl_db_table)
    $bbl_db_conn = OCI8.new(AppConfig.bbl_db_user, AppConfig.bbl_db_password, AppConfig.bbl_db_string)
    cursor = $bbl_db_conn.parse(sql)
  end

  def self.build_section(cursor)
    cursor.exec
    sections = Array.new

    while rs_row = cursor.fetch do
      section       = Section.new
      section.id   = rs_row[0]
      sections.push(section)
    end

    if sections.size > 1
      return sections
    else
      return section
    end
  end




end

