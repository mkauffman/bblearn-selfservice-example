class Section < ActiveRecord::Base
  establish_connection :oracle_development
  set_table_name "BBLEARN.COURSE_MAIN"
  set_primary_key "pk1"
  has_many :users, :through => :course_roles, :foreign_key => "course_id"

end

