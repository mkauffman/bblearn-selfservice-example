class RenameInstitutionRolePk1ToServiceRoleId < ActiveRecord::Migration
  def self.up
    rename_column :authorizations, :institution_role_pk1, :service_role_id
  end

  def self.down
    rename_column :authorizations, :service_role_id, :institution_role_pk1
  end
end
