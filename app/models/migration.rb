class Migration < ActiveRecord::Base
  establish_connection :vista_db
  set_table_name "BBL_MIGRATION"
end

