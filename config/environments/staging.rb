ShelterExchangeApp::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Enable threaded mode
  # config.threadsafe!

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Removed Spoofing check because it has disrupted some client's access.  Keep monitoring.
  config.action_dispatch.ip_spoofing_check = false

  # For nginx:
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # Enable serving of images, stylesheets, and javascripts from an asset server
  config.action_controller.asset_host = "shelterexchange-staging.s3.amazonaws.com"

  Rails.application.routes.default_url_options = { :host => 'se-staging.org' } # Fixes issue with Presenters not allowing Routes and Url Helper
  config.action_mailer.default_url_options     = { :host => 'se-staging.org' }
  config.action_mailer.delivery_method         = :sendmail
  config.action_mailer.sendmail_settings       = {:arguments => '-i'}

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Memcached
  # Use a different cache store in production
  # config.cache_store = :dalli_store, "127.0.0.1:11211"

  # Asset Pipeline
  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Choose the compressors to use
  config.assets.js_compressor  = :uglifier
  config.assets.css_compressor = :yui

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  #    This works but takes twice as long to precompile
  #    config.assets.precompile += ["*.js", "*.css"]
  # Javascripts
  config.assets.precompile += %W(
    admin.js
    api.js
    app_print.js
    login.js
    public.js
    selectivizr.js
    html5.js
  )
  # Stylesheets
  config.assets.precompile += %W(
    admin.css
    api.css
    app_print.css
    login.css
    public.css
    public_popup.css
  )
end

