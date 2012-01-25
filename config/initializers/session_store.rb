# Be sure to restart your server when you modify this file.
if Rails.env.development?
  ShelterExchangeApp::Application.config.session_store :cookie_store, :key => '_shelterexchange_session', :domain => :all
else
  ShelterExchangeApp::Application.config.session_store :cookie_store, :key => '_shelterexchange_session'
end

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ShelterExchangeApp::Application.config.session_store :active_record_store
