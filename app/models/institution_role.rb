class InstitutionRole < ActiveRecord::Base

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
  end

  def update
    ws_save_user
  end

  def new
    ws_save_user
  end

  def destroy
    ws_save_user
  end

end

