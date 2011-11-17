class Datasource < ActiveRecord::Base
  establish_connection "oracle_#{RAILS_ENV}"
  set_table_name "#{AppConfig.bbl_db_table}.DATA_SOURCE"
  set_primary_key "pk1"
  has_many :sections, :foreign_key => "data_src_pk1"
end