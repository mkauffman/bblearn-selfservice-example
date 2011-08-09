class UserRole < ActiveRecord::Base
  establish_connection :oracle_development
  set_table_name "BBLEARN2.USER_ROLES"
  set_primary_key "pk1"
  belongs_to :user, :foreign_key => "users_pk1"
  belongs_to :institution_role, :foreign_key => "institution_roles_pk1"
end

