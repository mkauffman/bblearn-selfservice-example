
require 'app_config'

module Permissions

  def sym_convert(roles)
    allowed_perms = Array.new

    allowed_perms.push(:proxy)                    if roles_comp(roles, AppConfig.perm_proxy.split(/,/))
    allowed_perms.push(:helpdesk)                 if roles_comp(roles, AppConfig.perm_helpdesk.split(/,/))
    allowed_perms.push(:logs)                     if roles_comp(roles, AppConfig.perm_logs.split(/,/))
    allowed_perms.push(:sso)                      if roles_comp(roles, AppConfig.perm_sso.split(/,/))
    allowed_perms.push(:sso_admin)                if roles_comp(roles, AppConfig.perm_sso_admin.split(/,/))
    allowed_perms.push(:sso_designer)             if roles_comp(roles, AppConfig.perm_sso_designer.split(/,/))
    allowed_perms.push(:sso_instructor_designer)  if roles_comp(roles, AppConfig.perm_sso_instructor_designer.split(/,/))
    allowed_perms.push(:sso_student)              if roles_comp(roles, AppConfig.perm_sso_student.split(/,/))

    if RoleCert.check_cert_required
      allowed_perms.push(:migration) if roles_comp(roles, AppConfig.perm_migration.split(/,/))
    end

    return allowed_perms

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

