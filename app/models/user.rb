require 'class_builder'

class User < ActiveRecord::Base
  extend ClassBuilder

  def self.find_by_course(course_id)
    sql = <<__SQL__
    SELECT *
    FROM dbTable.USERS usr
    JOIN (SELECT csu.USERS_PK1
          FROM dbTable.COURSE_USERS csu
          JOIN (SELECT csm.PK1
                FROM dbTable.COURSE_MAIN csm
                WHERE csm.COURSE_ID = :course_id) csi
          ON csu.CRSMAIN_PK1 = csi.PK1) crs
    ON usr.PK1 = crs.USERS_PK1
__SQL__

    # Substitute values into query and execute:
    cursor = build_cursor(sql)
    cursor.bind_param(':course_id', course_id)

#    logger.info ' *** The course \''+course_id+'\' found the following users: '+users.join(",")
    return build_class(cursor)
  end

  def self.find_by_course_and_role(course_id,role_name)
    sql = <<__SQL__
    SELECT *
    FROM dbTable.USERS usr
    JOIN (SELECT csu.USERS_PK1
          FROM dbTable.COURSE_USERS csu
          JOIN (SELECT csm.PK1
                FROM dbTable.COURSE_MAIN csm
                WHERE csm.COURSE_ID = :course_id) csi
          ON csu.CRSMAIN_PK1 = csi.PK1
          WHERE csu.ROLE = :role_name) crs
    ON usr.PK1 = crs.USERS_PK1
__SQL__

    # Substitute values into query and execute:
    cursor = build_cursor(sql)
    cursor.bind_param(':course_id', course_id)
    cursor.bind_param(':role_name', role_name)


    #logger.info ' *** The course \''+course_id+'\' found the following users with role \''+role_name+'\': '+users.join(",")
    return build_class(cursor)
  end

end

