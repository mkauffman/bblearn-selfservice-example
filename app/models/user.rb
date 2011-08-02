class User < ActiveRecord::Base
  establish_connection :oracle_development
  set_table_name "BBLEARN.USERS"
  set_primary_key "pk1"

end

