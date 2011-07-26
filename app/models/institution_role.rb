class InstitutionRole < ActiveRecord::Base

  def find_by_user(user_id)
    sql = <<__SQL__
    SELECT ins.ROLE_ID
    FROM BBLEARN.INSTITUTION_ROLES ins
    JOIN (SELECT rls.INSTITUTION_ROLES_PK1
          FROM BBLEARN.USER_ROLES rls
          JOIN (SELECT PK1
                FROM BBLEARN.USERS
                WHERE USER_ID = :user_id) usr
          ON rls.USERS_PK1 = usr.PK1) irl
    ON ins.PK1 = irl.INSTITUTION_ROLES_PK1

    UNION

    SELECT ins.ROLE_ID
    FROM BBLEARN.INSTITUTION_ROLES ins
    JOIN (SELECT usr.INSTITUTION_ROLES_PK1
          FROM BBLEARN.USERS usr
          WHERE usr.USER_ID = :user_id) irl
    ON ins.PK1 = irl.INSTITUTION_ROLES_PK1
__SQL__

    cursor = build_cursor(sql)
    cursor.bind_param(':user_id', user_id)

    return build_class(cursor)
  end

end

