class InstitutionRole < ActiveRecord::Base
  establish_connection :oracle_development
  set_table_name "BBLEARN2.INSTITUTION_ROLES"
  set_primary_key "pk1"
  has_many :user_roles, :foreign_key => "institution_roles_pk1"
end

