class InstitutionRole < ActiveRecord::Base
  establish_connection :oracle_development
  set_table_name "BBLEARN.INSTITUTION_ROLES"
  set_primary_key "pk1"

end
