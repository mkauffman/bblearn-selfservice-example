# =============================================================================
# ROLES
# =============================================================================
role :web, "apphostdev.csuchico.edu"
role :app, "apphostdev.csuchico.edu"
role :db,  "apphostdev.csuchico.edu", :primary=>true
set :branch, "staging"
set :repository_cache, "git_master"
