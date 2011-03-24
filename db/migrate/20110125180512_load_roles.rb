class LoadRoles < ActiveRecord::Migration
  require 'active_record/fixtures'
  
  def self.up
    directory = File.join(File.dirname(__FILE__), "initial_data")
    Fixtures.create_fixtures(directory, "roles")
  end

  def self.down
    Roles.delete_all
  end
end
