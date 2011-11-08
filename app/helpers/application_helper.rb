# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def user_is_allowed?(options={})
    controller = options[:controller] || controller_name 
    action     = options[:action]     || action_name 
    session[:user_object].allowed? controller, action
  end
  
  def user_is_admin?
    true if session[:user_object].service_role.name == "admin"
    false unless session[:user_object].service_role.name == "admin"
  end  
  
end

