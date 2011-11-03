class AddAllowedToAuthorizations < ActiveRecord::Migration
  def self.up
    add_column :authorizations, :allowed, :boolean
  end

  def self.down
    remove_column :authorizations, :allowed
  end
end
