class CAManagement < ActiveRecord::Base
  has_many :authorizations, :dependent => :delete_all
  
  def full_title
    self.controller.to_s + "-" + self.action.to_s
  end

  def self.all_order_by_controller
  	ca_managements = CAManagement.all
  	ca_managements.sort! { |a,b| a.controller.downcase <=> b.controller.downcase }
  end

end
