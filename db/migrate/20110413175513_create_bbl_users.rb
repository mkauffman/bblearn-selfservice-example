class CreateBblUsers < ActiveRecord::Migration
  def self.up
    create_table :bbl_users do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :bbl_users
  end
end
