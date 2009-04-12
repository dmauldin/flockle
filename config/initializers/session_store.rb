# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_twelevant_session',
  :secret      => '4ac387068ed6e7be11961f65ffef808fd14ab795e67779cf2a1c4e2385a9c75cfe7965d4c1debd34e5995d6bc77c55d5dcf58853042ad78c07a7bde8a3dc3828'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
