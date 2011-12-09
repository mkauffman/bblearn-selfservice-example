class RemoveInstitutionRolesPk1FromAuthorizations < ActiveRecord::Migration
  def self.up
  	remove_column :authorizations, :institution_roles_pk1
  end

  def self.down
  end
end
