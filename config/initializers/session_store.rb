# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_vista_session',
  :secret      => '1bd329bc80eb0bb2ef96a1047b61e3c1d7cc12335f83dfcd3751cb05440fc653e7d8cf9acae79de8f04a9b67248b2664e5659e11b8a4dbbab001db33ddd95057'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
