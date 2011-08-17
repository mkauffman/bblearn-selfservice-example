# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
include Permissions  
    def roles_comp(roles, granted_roles)
      intersection = roles.to_a & granted_roles.to_a
      if intersection.empty?
        return false
      else
        return true
      end
  end
  
end

