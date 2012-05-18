class CourseTerm < ActiveRecord::Base
  # "The name of the other model is pluralized when declaring a has_many association."
  # http://guides.rubyonrails.org/association_basics.html
  establish_connection "oracle_#{RAILS_ENV}"
  set_table_name "#{AppConfig.bbl_db_table}.COURSE_TERM"
  set_primary_key "pk1"
  belongs_to :section, :foreign_key => "crsmain_pk1"
  belongs_to :term, :foreign_key => "term_pk1"

end
