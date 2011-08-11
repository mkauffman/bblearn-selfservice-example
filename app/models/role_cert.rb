require 'logger'

class RoleCert < ActiveRecord::Base
  validates_uniqueness_of :portal_id
  validates_presence_of :portal_id, :role

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

