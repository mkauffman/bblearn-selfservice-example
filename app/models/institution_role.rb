class InstitutionRole < ActiveRecord::Base
  establish_connection "oracle_#{RAILS_ENV}"
  set_table_name "#{AppConfig.bbl_db_table}.INSTITUTION_ROLES"
  set_primary_key "pk1"
  has_many :user_roles, :foreign_key => "institution_roles_pk1"
end

