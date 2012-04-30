class AddRoleIdToUserServiceRoleId < ActiveRecord::Migration
  def self.up
    add_column :service_roles, :role_id, :integer
    remove_column :service_roles, :ca_management_id
  end

  def self.down
    remove_column :user_services, :role_id
  end
end
