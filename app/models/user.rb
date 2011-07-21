require 'active_record/validations'

class User
  attr_accessor :source_id, :source, :empl_id, :webct_id, :full_name, :last_name,
                :first_name, :name_prefix, :name_suffix, :nickname, :email,
                :datasource, :is_mail_forwarded, :status, :role, :exists

  attr_accessor :errors
#TODO: Change the BBLEARN values below to dbTable (after they are global)
  def initialize(opts = {})
    @errors = ActiveRecord::Errors.new(self)
  end

  def save
  end


  def save!
  end

  def new_record?
    false
  end


  def update_attribute
  end


  include ActiveRecord::Validations

  def self.find_by_course(course_id)
    sql = <<__SQL__
    SELECT usr.USER_ID, usr.FIRSTNAME, usr.LASTNAME, usr.EMAIL
    FROM BBLEARN.USERS usr
    JOIN (SELECT csu.USERS_PK1
          FROM BBLEARN.COURSE_USERS csu
          JOIN (SELECT csm.PK1
                FROM BBLEARN.COURSE_MAIN csm
                WHERE csm.COURSE_ID = :course_id) csi
          ON csu.CRSMAIN_PK1 = csi.PK1) crs
    ON usr.PK1 = crs.USERS_PK1
__SQL__

    # Substitute values into query and execute:
#    sql = sql.gsub!("dbTable",$bbl_db_table)
    $bbl_db_conn = OCI8.new(AppConfig.bbl_db_user, AppConfig.bbl_db_password, AppConfig.bbl_db_string)
    cursor = $bbl_db_conn.parse(sql)
    cursor.bind_param(':course_id', course_id)
    cursor.exec

    # Load results into array, log and return:
    users = Array.new
    while rs_row = cursor.fetch do
      users.push(rs_row.to_s)
    end
#    logger.info ' *** The course \''+course_id+'\' found the following users: '+users.join(",")
    return cursor
  end


  def find_by_course_and_role(course_id,role_name)
    sql = <<__SQL__
    SELECT usr.USER_ID, usr.FIRSTNAME, usr.LASTNAME, usr.EMAIL
    FROM BBLEARN.USERS usr
    JOIN (SELECT csu.USERS_PK1
          FROM BBLEARN.COURSE_USERS csu
          JOIN (SELECT csm.PK1
                FROM BBLEARN.COURSE_MAIN csm
                WHERE csm.COURSE_ID = :course_id) csi
          ON csu.CRSMAIN_PK1 = csi.PK1
          WHERE csu.ROLE = :role_name) crs
    ON usr.PK1 = crs.USERS_PK1
__SQL__

    # Substitute values into query and execute:
    sql = sql.gsub!("dbTable",$bbl_db_table)
    cursor = $bbl_db_conn.parse(sql)
    cursor.bind_param(':course_id', course_id)
    cursor.bind_param(':role_name', role_name)
    cursor.exec

    # Load results into array, log and return:
    users = Array.new
    while rs_row = cursor.fetch do
      users.push(rs_row.to_s)
    end
    logger.info ' *** The course \''+course_id+'\' found the following users with role \''+role_name+'\': '+users.join(",")
    return users
  end

end

