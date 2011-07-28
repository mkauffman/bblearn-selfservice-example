class Course < ActiveRecord::Base
  establish_connection :oracle_development
  set_table_name "course_main"
  set_primary_key "pk1"



end

