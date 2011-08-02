class CourseRole < ActiveRecord::Base
  establish_connection :oracle_development
  set_table_name "BBLEARN.COURSE_USERS"
  set_primary_key "pk1"

end

