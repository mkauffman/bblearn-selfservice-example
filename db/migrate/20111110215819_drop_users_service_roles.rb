class DropUsersServiceRoles < ActiveRecord::Migration
  def self.up
    drop_table :service_roles
  end

  def self.down
  end
end
