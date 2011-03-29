class CreateBblSections < ActiveRecord::Migration
  def self.up
    create_table :bbl_sections do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :bbl_sections
  end
end
