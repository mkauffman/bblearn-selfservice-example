require 'class_builder'

class User < ActiveRecord::Base
  extend ClassBuilder

  def self.find_by_section(section_id)
    sql = <<__SQL__
    SELECT *
    FROM dbTable.USERS usr
    JOIN (SELECT csu.USERS_PK1
          FROM dbTable.COURSE_USERS csu
          JOIN (SELECT csm.PK1
                FROM dbTable.section_MAIN csm
                WHERE csm.COURSE_ID = :section_id) csi
          ON csu.CRSMAIN_PK1 = csi.PK1) crs
    ON usr.PK1 = crs.USERS_PK1
__SQL__

    # Substitute values into query and execute:
    cursor = build_cursor(sql)
    cursor.bind_param(':section_id', section_id)
    
    #logger.info ' *** The section \''+section_id+'\' found the following users: '+users.join(",")
    return build_class(cursor)
  end

  def self.find_by_section_and_role(section_id,role_name)
    sql = <<__SQL__
    SELECT *
    FROM dbTable.USERS usr
    JOIN (SELECT csu.USERS_PK1
          FROM dbTable.COURSE_USERS csu
          JOIN (SELECT csm.PK1
                FROM dbTable.COURSE_MAIN csm
                WHERE csm.COURSE_ID = :section_id) csi
          ON csu.CRSMAIN_PK1 = csi.PK1
          WHERE csu.ROLE = :role_name) crs
    ON usr.PK1 = crs.USERS_PK1
__SQL__

    # Substitute values into query and execute:
    cursor = build_cursor(sql)
    cursor.bind_param(':section_id', section_id)
    cursor.bind_param(':role_name', role_name)

    #logger.info ' *** The section \''+section_id+'\' found the following users with role \''+role_name+'\': '+users.join(",")
    return build_class(cursor)
  end

end

