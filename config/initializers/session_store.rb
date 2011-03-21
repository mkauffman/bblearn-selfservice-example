# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_bblearn_session',
  :secret      => '599db9e9540e2520b642eee06c96f2e845ad9e21c5f447c047453c1c285a2fa7e2e5a8f9abe1937dac7a220f4c548fe801d94e874ba06dd18d7e7ec98cf05828'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
