
require 'app_config'

module Permissions

  def sym_convert(roles)
    allowed_perms = Array.new

    if proxy(roles)
      allowed_perms.push("proxy".to_sym)
    end
      
    if migration(roles)
      allowed_perms.push("migration".to_sym)
    end
    
    if helpdesk(roles)
      allowed_perms.push("helpdesk".to_sym)
    end

    return allowed_perms

  end

  def proxy(roles)
    if roles_comp(roles, AppConfig.perm_proxy.split(/,/))
      return true
    end
    return false
  end


  def migration(roles)
    unless Role.check_cert_required
      return true
    end
    if roles_comp(roles, AppConfig.perm_migration.split(/,/))
      return true
    end
    return false
  end

  def helpdesk(roles)
    if roles_comp(roles, AppConfig.perm_helpdesk.split(/,/))
      return true
    end
    return false
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
