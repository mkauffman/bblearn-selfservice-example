class Tpextract < ActiveRecord::Base
  establish_connection "oracle_#{RAILS_ENV}"
  set_table_name "#{AppConfig.bbl_db_table}.BBTP_USER_RESPDEVID"
end

