# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_AvailableToPair_session',
  :secret      => '962e29c32541d7538f8ac7401172861f4fca3dd6ab96356fc11fe34957300137e02b6e77ab7467c2e73cea05746ab197892c57a82417825761c21d864eda9a86'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
