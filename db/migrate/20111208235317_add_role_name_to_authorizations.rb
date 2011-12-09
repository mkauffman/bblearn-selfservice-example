class AddRoleNameToAuthorizations < ActiveRecord::Migration
  def self.up
    add_column :authorizations, :role_name, :string
  end

  def self.down
    remove_column :authorizations, :role_name
  end
end
