class RenameUsedRoleToServiceRole < ActiveRecord::Migration
  def self.up
    rename_table :used_roles, :service_roles
  end

  def self.down
    rename_table :service_roles, :used_roles
  end
end
