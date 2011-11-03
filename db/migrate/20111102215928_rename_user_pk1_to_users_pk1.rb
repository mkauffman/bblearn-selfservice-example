class RenameUserPk1ToUsersPk1 < ActiveRecord::Migration
  def self.up
    rename_column :user_service_roles, :user_pk1, :users_pk1
  end

  def self.down
  end
end
