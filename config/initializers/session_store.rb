# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_bblearn_selfservice_session',
  :secret      => '92bdc27eb694fdb073b3bcdf232f64ee5564cecd2a6536f0a44581241465e04254477c343d68839d8ae78524bf68eba58b3036230fa1e7c21aabcad7e0ed688f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store
