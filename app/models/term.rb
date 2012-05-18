class Term < ActiveRecord::Base
  establish_connection "oracle_#{RAILS_ENV}"
  set_table_name "#{AppConfig.bbl_db_table}.TERM"
  set_primary_key "pk1"
  has_many :course_term, :foreign_key => "term_pk1"
end
