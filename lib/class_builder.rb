require 'map'
require 'app_config'

module ClassBuilder

  def build_cursor(sql)
    # Substitute values into query and execute:
    $bbl_db_table = AppConfig.bbl_db_table
    sql = sql.gsub!("dbTable",$bbl_db_table)
    $bbl_db_conn = OCI8.new(AppConfig.bbl_db_user, AppConfig.bbl_db_password, AppConfig.bbl_db_string)
    cursor = $bbl_db_conn.parse(sql)
  end

  def build_class(cursor)
    cursor.exec
    col_names = cursor.get_col_names
    attributes = Hash.new
    objects = Array.new

    while rs_row = cursor.fetch do
      c = col_names.reverse
      rs_row.each do |r|
        attributes[c.pop.downcase] = r
        c = c
      end
      object = Map.new(attributes)
      objects.push(object)
    end

    if object.size > 1
      return objects
    else
      return object
    end
  end



end

