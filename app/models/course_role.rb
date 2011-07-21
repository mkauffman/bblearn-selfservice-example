class CourseRole < ActiveRecord::Base
  def self.columns() @columns ||= []; end

  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
  end

  column :id, :string

  validates_uniqueness_of :portal_id
  validates_presence_of :portal_id, :role

  def find
  end

  def new
    ws_save_course_membership :course_id => self.course_id,
      :user_id => self.user_id
  end

  def destroy
    ws_delete_course_membership :ids => self.id
  end

end

