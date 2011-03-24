class AddAttachmentsStudentListToSection < ActiveRecord::Migration
  def self.up

    add_column :sections, :student_list_file_name, :string
    add_column :sections, :student_list_content_type, :string
    add_column :sections, :student_list_file_size, :integer
    add_column :sections, :student_list_updated_at, :datetime

  end

  def self.down

    remove_column :sections, :student_list_file_name
    remove_column :sections, :student_list_content_type
    remove_column :sections, :student_list_file_size
    remove_column :sections, :student_list_updated_at

  end
end
