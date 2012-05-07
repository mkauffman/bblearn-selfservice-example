class CreateCourseModels < ActiveRecord::Migration
  def self.up
    create_table :course_models do |t|
      t.string :course_id
      t.string :friendly_name

      t.timestamps
    end
  end

  def self.down
    drop_table :course_models
  end
end
