class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :portal_id
      t.string :first_name
      t.string :last_name
      t.string :role

      t.timestamps
    end
  end

  def self.down
    drop_table :roles
  end
end
