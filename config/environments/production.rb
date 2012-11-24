ShelterExchangeApp::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Removed Spoofing check because it has disrupted some client's access.  Keep monitoring.
  config.action_dispatch.ip_spoofing_check = false

  # For nginx:
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # Enable serving of images, stylesheets, and javascripts from an asset server
  config.action_controller.asset_host = 'http://shelterexchange.s3.amazonaws.com'

#TODO
            # Compress JavaScripts and CSS
            # config.assets.compress = true

            # Don't fallback to assets pipeline if a precompiled asset is missed
            # config.assets.compile = false

            # Generate digests for assets URLs
            # config.assets.digest = true
  
  Rails.application.routes.default_url_options = { :host => 'shelterexchange.org' } # Fixes issue with Presenters not allowing Routes and Url Helper
  config.action_mailer.default_url_options     = { :host => 'shelterexchange.org' }
  config.action_mailer.delivery_method         = :sendmail
  config.action_mailer.sendmail_settings       = {:arguments => '-i'}

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
end


# Not needed right now
# -------------------------
  # Use a different cache store in production
  # config.cache_store = :dalli_store, "127.0.0.1:11211"

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe! unless $rails_rake_task
