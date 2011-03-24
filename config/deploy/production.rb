# =============================================================================
# ROLES
# =============================================================================
role :web, "apphost.csuchico.edu"
role :app, "apphost.csuchico.edu"
role :db,  "apphost.csuchico.edu", :primary=>true
set :branch, "master"
set :repository_cache, "git_master"
