class VistaSection < ActiveRecord::Base
  establish_connection :vista_db
  set_table_name "WEBCT.LEARNING_CONTEXT"
  set_primary_key "id"
end
