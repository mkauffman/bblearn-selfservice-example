class CreateBblCourses < ActiveRecord::Migration
  def self.up
    create_table :bbl_courses do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :bbl_courses
  end
end
