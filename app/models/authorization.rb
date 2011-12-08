class Authorization < ActiveRecord::Base
  belongs_to :institution_role, :foreign_key => 'institution_role_pk1'
  belongs_to :ca_management

  validates_presence_of :institution_roles_pk1
end
