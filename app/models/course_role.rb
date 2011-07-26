require 'class_builder'
class CourseRole < ActiveRecord::Base
  extend ClassBuilder
  def find_by_section
  end

  def find_by_user_and_section(user_id,course_id)
    sql = <<__SQL__
        SELECT csu.PK1
        FROM BBLEARN2.COURSE_USERS csu

        JOIN (SELECT PK1
        FROM BBLEARN2.USERS
        WHERE USER_ID = :user_id) usr
        ON csu.USERS_PK1 = usr.PK1

        JOIN (SELECT PK1
        FROM BBLEARN2.COURSE_MAIN
        WHERE COURSE_ID = :course_id) crs
        ON csu.CRSMAIN_PK1 = crs.PK1
__SQL__

    cursor = build_cursor(sql)
    cursor.bind_param(':user_id', user_id)
    cursor.bind_param(':course_id', course_id)

    #logger.info ' *** The user \''+user_id+'\' is in the following courses: '+courses.join(",")
    return build_class(cursor)
  end

  def update
    ws_save_course_membership
  end

  def new
    ws_save_course_membership
  end

  def destroy
    ws_delete_course_membership
  end

end

