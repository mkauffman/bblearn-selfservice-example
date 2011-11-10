class ChangeAuthorizations < ActiveRecord::Migration
  def self.up
    add_column :authorizations, :institution_roles_pk1, :integer
    remove_column :authorizations, :service_role_id
  end

  def self.down
  end
end
