class User
  attr_accessor :id, :first_name, :last_name, :email

  def self.find_by_course(course_id)
    sql = <<__SQL__
    SELECT usr.USER_ID, usr.FIRSTNAME, usr.LASTNAME, usr.EMAIL
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
    cursor = User.build_cursor(sql)
    cursor.bind_param(':course_id', course_id)

#    logger.info ' *** The course \''+course_id+'\' found the following users: '+users.join(",")
    return User.build_user(cursor)
  end

  def self.find_by_course_and_role(course_id,role_name)
    sql = <<__SQL__
    SELECT usr.USER_ID, usr.FIRSTNAME, usr.LASTNAME, usr.EMAIL
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
    cursor = User.build_cursor(sql)
    cursor.bind_param(':course_id', course_id)
    cursor.bind_param(':role_name', role_name)


    #logger.info ' *** The course \''+course_id+'\' found the following users with role \''+role_name+'\': '+users.join(",")
    return User.build_user(cursor)
  end

  def self.build_cursor(sql)
    $bbl_db_table = AppConfig.bbl_db_table
    sql = sql.gsub!("dbTable",$bbl_db_table)
    $bbl_db_conn = OCI8.new(AppConfig.bbl_db_user, AppConfig.bbl_db_password, AppConfig.bbl_db_string)
    cursor = $bbl_db_conn.parse(sql)
  end

  def self.build_user(cursor)
    cursor.exec
    users = Array.new

    while rs_row = cursor.fetch do
      user            = User.new
      user.id         = rs_row[0]
      user.first_name = rs_row[1]
      user.last_name  = rs_row[2]
      user.email      = rs_row[3]
      users.push(user)
    end

    if users.size > 1
      return users
    else
      return user
    end
  end


end

