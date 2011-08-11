class Tpextract < ActiveRecord::Base
  establish_connection :oracle_development
  set_table_name "BBLEARN2.BBTP_USER_RESPDEVID"
end

