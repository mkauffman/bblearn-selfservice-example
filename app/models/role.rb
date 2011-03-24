class Role < ActiveRecord::Base
  validates_uniqueness_of :portal_id
  validates_presence_of :portal_id, :role
end
