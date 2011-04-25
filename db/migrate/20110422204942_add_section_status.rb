class AddSectionStatus < ActiveRecord::Migration
  def self.up
    add_column :sections, :status, :string
  end

  def self.down
    remove_column :sections, :status
  end
end
