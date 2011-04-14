class CreateBblCourseMemberships < ActiveRecord::Migration
  def self.up
    create_table :bbl_course_memberships do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :bbl_course_memberships
  end
end
