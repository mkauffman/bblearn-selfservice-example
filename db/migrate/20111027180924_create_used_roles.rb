class CreateUsedRoles < ActiveRecord::Migration
  def self.up
    create_table :used_roles do |t|
      t.string :name
      t.integer :institution_role_pk1

      t.timestamps
    end
  end

  def self.down
    drop_table :used_roles
  end
end
