class InstitutionRole < ActiveRecord::Base
  def self.columns() @columns ||= []; end

  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
  end

  column :id, :string

  validates_uniqueness_of :portal_id
  validates_presence_of :portal_id, :role

  def find_by_user_id
  end

  def all
  end

  def find
  end

  def update
    ws_save_user
  end

  def new
    ws_save_user
  end

  def destroy
    ws_save_user
  end

end

