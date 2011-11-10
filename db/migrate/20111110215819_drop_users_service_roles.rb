class DropUsersServiceRoles < ActiveRecord::Migration
  def self.up
    drop_table :user_service_roles
  end

  def self.down
  end
end
