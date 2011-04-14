class AddLoggedIn < ActiveRecord::Migration
  def self.up
    add_column :bbl_contexts, :logged_in, :boolean
  end

  def self.down
    remove_column :bbl_contexts, :logged_in
  end
end
