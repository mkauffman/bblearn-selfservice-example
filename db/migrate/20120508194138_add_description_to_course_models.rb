class AddDescriptionToCourseModels < ActiveRecord::Migration
  def self.up
    add_column :course_models, :description, :text
  end

  def self.down
    remove_column :course_models, :description
  end
end
