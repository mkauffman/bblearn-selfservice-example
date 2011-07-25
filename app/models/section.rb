require 'map'

class Section < ActiveRecord::Base

  def self.fill_attributes(attributes)
    attributes.each do |key, value|
      update_attribute key, value
    end
  end


  def self.find_by_user(user_id)
    sql = <<__SQL__
    SELECT *
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
    col_names = cursor.get_col_names
    attributes = Hash.new
    sections = Array.new
    puts col_names.inspect

    while rs_row = cursor.fetch do
      c = col_names.reverse
      rs_row.each do |r|
        attributes[c.pop.downcase.to_sym] = r
        c = c
      end
      section           = Section.new
      section           = Section.fill_attributes(attributes)
      sections.push(section)
    end

    if sections.size > 1
      return sections
    else
      return section
    end
  end




end

