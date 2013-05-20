# ShelterExchangeApp::Application.configure do
#   # Settings specified here will take precedence over those in config/environment.rb
#
#   # The production environment is meant for finished, "live" apps.
#   # Code is not reloaded between requests
#   config.cache_classes = true
#
#   # Full error reports are disabled and caching is turned on
#   config.consider_all_requests_local       = false
#   config.action_controller.perform_caching = true
#
#   # Enable threaded mode
#   # config.threadsafe!
#
#   # Use a different logger for distributed setups
#   # config.logger = SyslogLogger.new
#
#   # Disable Rails's static asset server (Apache or nginx will already do this)
#   config.serve_static_assets = false
#
#   # Removed Spoofing check because it has disrupted some client's access.  Keep monitoring.
#   config.action_dispatch.ip_spoofing_check = false
#
#   # For nginx:
#   config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'
#
#   # Enable serving of images, stylesheets, and javascripts from an asset server
#   config.action_controller.asset_host = "//shelterexchange-development.s3.amazonaws.com"
#
#   # Asset Pipeline
#   # Compress JavaScripts and CSS
#   config.assets.compress = true
#
#   # Choose the compressors to use
#   config.assets.js_compressor  = :uglifier
#   config.assets.css_compressor = :yui
#
#   # Don't fallback to assets pipeline if a precompiled asset is missed
#   config.assets.compile = false
#
#   # Generate digests for assets URLs
#   config.assets.digest = true
#
#   # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
#   # Javascripts
#   config.assets.precompile += %W(
#     admin.js
#     api.js
#     app_print.js
#     login.js
#     public.js
#     selectivizr.js
#     html5.js
#   )
#   # Stylesheets
#   config.assets.precompile += %W(
#     admin.css
#     api.css
#     app_print.css
#     login.css
#     public.css
#     public_popup.css
#   )
#
#   # Use a different cache store in production
#   # config.cache_store = :dalli_store, "127.0.0.1:11211"
#
#   Rails.application.routes.default_url_options = { :host => 'lvh.me', :port => 3000 } # Fixes issue with Presenters not allowing Routes and Url Helper
#
#   config.action_mailer.default_url_options = { :host => 'lvh.me', :port => 3000 }
#   config.action_mailer.delivery_method = :sendmail
#
#   # Disable delivery errors, bad email addresses will be ignored
#   # config.action_mailer.raise_delivery_errors = false
#
#   # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
#   # the I18n.default_locale when a translation can not be found)
#   config.i18n.fallbacks = true
#
#   # Send deprecation notices to registered listeners
#   config.active_support.deprecation = :notify
# end



# Fix foreman logging issue
$stdout.sync = true

ShelterExchangeApp::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  Rails.application.routes.default_url_options = { :host => 'lvh.me', :port => 3000 } # Fixes issue with Presenters not allowing Routes and Url Helper

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_deliveries = true
  config.action_mailer.default :charset => 'utf-8'

  config.action_mailer.default_url_options = { :host => 'lvh.me', :port => 3000 }
  config.action_mailer.delivery_method = :sendmail

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Asset Pipeline
  config.assets.compress = false
  config.assets.debug    = true
  config.quiet_assets    = true

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

#TODO
              # Testing MEMCACHE
              # config.action_controller.perform_caching = true
              # config.cache_store = :dalli_store, "127.0.0.1:11211"

            # Raise exception on mass assignment protection for Active Record models
            # config.active_record.mass_assignment_sanitizer = :strict
end

