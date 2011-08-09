require 'logger'

class Role < ActiveRecord::Base
  validates_uniqueness_of :portal_id
  validates_presence_of :portal_id, :role
  
  def self.find(webct_id)
    sql = <<__SQL__
    
    SELECT ins.ROLE_ID
    FROM dbTable.INSTITUTION_ROLES ins
    JOIN (SELECT INSTITUTION_ROLES_PK1
          FROM dbTable.USERS usr
          WHERE usr.USER_ID = :webct_id) primary_ids
    ON ins.PK1 = primary_ids.INSTITUTION_ROLES_PK1
    
    UNION 
    
    SELECT ins.ROLE_ID
    FROM dbTable.INSTITUTION_ROLES ins
    JOIN (SELECT rls.INSTITUTION_ROLES_PK1
          FROM dbTable.USERS usr
          JOIN dbTable.USER_ROLES rls
          ON usr.PK1        = rls.USERS_PK1
          WHERE usr.USER_ID = :webct_id) secondary_ids
    ON ins.PK1 = secondary_ids.INSTITUTION_ROLES_PK1
__SQL__
 
    # Retrieve roles from database:
    sql = sql.gsub!("dbTable",$bbl_db_table)
    cursor = $bbl_db_conn.parse(sql)
    cursor.bind_param(':webct_id', webct_id)
    cursor.exec
    
    # Push roles into array:
    roles = Array.new
    while rs_row = cursor.fetch do
      roles.push(rs_row.to_s)
    end
    logger.info ' *** User \''+webct_id+'\' retrieved the roles: '+roles.join(",")
        
    return roles
  end


  def self.check_cert_required
    sql = <<__SQL__
      SELECT LRN_CRT_REQUIRED
      FROM BBL_MIG_CONF
      WHERE PK = '1'
__SQL__

    cursor = $vista_db_conn.parse(sql)
    cursor.exec
    rs_row = cursor.fetch_hash
    if rs_row['LRN_CRT_REQUIRED'] == 1
      return true
    end
    return false
  end
  
  
  def self.update_cert_required(bool)
    sql = <<__SQL__
      UPDATE BBL_MIG_CONF
      SET LRN_CRT_REQUIRED = :boolean
      WHERE PK='1'
__SQL__
    
    cursor = $vista_db_conn.parse(sql)
    if bool
      cursor.bind_param(':boolean', '1')
    else
      cursor.bind_param(':boolean', '0')
    end
    cursor.exec
    $vista_db_conn.commit
  end
  
  
end
