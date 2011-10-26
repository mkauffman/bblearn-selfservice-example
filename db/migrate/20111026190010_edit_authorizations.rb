class EditAuthorizations < ActiveRecord::Migration
  def self.up
    remove_column :authorizations, :action
    remove_column :authorizations, :controller
    remove_column :authorizations, :role
    add_column :authorizations, :ca_management_id, :integer
    add_column :authorizations, :institution_role_pk1, :integer
  end

  def self.down
  end
end
