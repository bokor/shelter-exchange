require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require 'rails/all'
#require "rails/test_unit/railtie"
#require "active_record/railtie"
#require "action_controller/railtie"
#require "action_mailer/railtie"
#require "active_resource/railtie"
#require "sprockets/railtie"

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module ShelterExchangeApp
  class Application < Rails::Application

    # Core Extension: Require any ruby extensions (Ex. String, Array)
    config.autoload_paths += Dir["#{config.root}/lib/core_ext/*.rb"].each {|f| require f }

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(
      #{config.root}/lib
      #{config.root}/lib/validators
      #{config.root}/app/observers
      #{config.root}/app/presenters
      #{config.root}/app/uploaders
      #{config.root}/app/models/concerns
    )

    # Activate observers that should always be running.
    Dir.chdir("#{Rails.root}/app/observers") do
      config.active_record.observers = Dir["*_observer.rb"].collect {|ob_name| ob_name.split(".").first }
    end

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = "Pacific Time (US & Canada)"

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # Added to load the international Files by folder name - streamlined into subfolders
    config.i18n.enforce_available_locales = true
    #config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    #config.i18n.default_locale = :es

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :password_confirmation]

    # RSpec - Setup factory generators
    config.generators do |g|
      g.test_framework      :rspec, :fixture => true
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
    end

    # Asset pipeline
    config.assets.enabled = true       # Enable the asset pipeline
    config.assets.version = '1.0'      # Version of your assets, change this if you want to expire all your assets
    config.assets.prefix = "/assets"

    config.assets.paths << Rails.root.join("app/assets/documents")
    # config.assets.paths << Rails.root.join("app/assets/html")

    # Devise - Allows Devise to use the UrlHelper file for Subdomain links in the emails.
    config.to_prepare do
      Devise::Mailer.class_eval do
        helper :url
      end
    end

  end
end

    # Enable escaping HTML in JSON.
    # config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    # config.active_record.whitelist_attributes = true
#
