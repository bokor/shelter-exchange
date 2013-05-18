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
  config.quiet_assets    = false

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

