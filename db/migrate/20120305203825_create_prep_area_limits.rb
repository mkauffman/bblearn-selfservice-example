class CreatePrepAreaLimits < ActiveRecord::Migration
  def self.up
    create_table :prep_area_limits do |t|
      t.string :role
      t.integer :limit

      t.timestamps
    end
  end

  def self.down
    drop_table :prep_area_limits
  end
end
