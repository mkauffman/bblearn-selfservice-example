class CreateDbsessions < ActiveRecord::Migration
   def self.up
    create_table :dbsessions do |t|
      t.string :session_number
      t.string :section_id
      t.string :section_type
      t.string :section_parent

      t.timestamps
    end
  end

  def self.down
    drop_table :dbsessions
  end
end
