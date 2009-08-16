# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_webservice_session',
  :secret      => '6c70a5df985ddea4baed7c3a5bb7a641a0e4196ef86bf4fba847fd7691d584bf8c9b0df240a1ecbc23ffb7f7a6c19e0e03b7d5e8f314a878bbcc437f0ec05b5f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
