require 'class_builder'

class Section < ActiveRecord::Base
  extend ClassBuilder

  def self.find(id)
    sql = <<__SQL__
    SELECT *
    FROM dbTable.COURSE_MAIN
    WHERE PK1 = :id
__SQL__

    cursor = build_cursor(sql)
    cursor.bind_param(':id', id)

    #logger.info ' *** The user \''+user_id+'\' is in the following courses: '+courses.join(",")
    return build_class(cursor)
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


    cursor = build_cursor(sql)
    cursor.bind_param(':user_id', user_id)

    #logger.info ' *** The user \''+user_id+'\' is in the following courses: '+courses.join(",")
    return build_class(cursor)
  end


  def self.find_by_user_and_role(user_id,role_name)
    sql = <<__SQL__
    SELECT *
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

    cursor = build_cursor(sql)
    cursor.bind_param(':user_id', user_id)
    cursor.bind_param(':role_name', role_name)

    #logger.info ' *** The user \''+user_id+'\' is in the following courses with role \''+role_name+'\': '+courses.join(",")
    return build_class(cursor)
  end

end

