class CAManagement < ActiveRecord::Base
  has_many :authorizations, :dependent => :delete_all
  
  def full_title
    self.controller.to_s + "-" + self.action.to_s
  end
end
