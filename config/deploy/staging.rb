# =============================================================================
# ROLES
# =============================================================================
role :web, "apphostdev.csuchico.edu"
role :app, "apphostdev.csuchico.edu"
role :db,  "apphostdev.csuchico.edu", :primary=>true
set :branch, "master"
set :repository_cache, "git_staging"
