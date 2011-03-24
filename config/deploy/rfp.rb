# =============================================================================
# ROLES
# =============================================================================
role :web, "apphost.csuchico.edu"
role :app, "apphost.csuchico.edu"
role :db,  "apphost.csuchico.edu", :primary=>true
set :branch, "rfp"
set :repository_cache, "git_rfp"
set :deploy_to, "/h/dlt/opt/RailsApps/bblearn-rfp"
