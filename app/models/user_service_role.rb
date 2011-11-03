class UserServiceRole < ActiveRecord::Base
  belongs_to :user, :foreign_key => "users_pk1"
  belongs_to :service_role, :foreign_key => "role_id"
end
