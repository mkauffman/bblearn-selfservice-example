class AddCaManagementIdToUserServiceRoles < ActiveRecord::Migration
  def self.up
    add_column :user_service_roles, :ca_management_id, :integer
    add_column :user_service_roles, :user_pk1, :integer
  end

  def self.down
    remove_column :user_service_roles, :user_pk1
    remove_column :user_service_roles, :ca_management_id
  end
end
