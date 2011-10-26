
require 'app_config'

module Permissions

  def sym_convert(roles)
  end

  def roles_comp(roles, config_roles)
    intersection = Array.new
    intersection = roles.to_a & config_roles.to_a
    if intersection.empty?
      return false
    else
      return true
    end

  end

end

