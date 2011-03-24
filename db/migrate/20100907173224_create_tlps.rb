class CreateTlps < ActiveRecord::Migration
  def self.up
    create_table :tlps do |t|
      t.text :html_type
      t.text :html
      t.timestamps
    end
  end

  def self.down
    drop_table :tlps
  end
end
