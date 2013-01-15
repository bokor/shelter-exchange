# Be sure to restart your server when you modify this file.
if Rails.env.development?
  ShelterExchangeApp::Application.config.session_store :cookie_store, :key => '_shelterexchange_session', :domain => :all
else
  ShelterExchangeApp::Application.config.session_store :cookie_store, :key => '_shelterexchange_session'
end
