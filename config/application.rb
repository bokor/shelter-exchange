require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module ShelterExchangeApp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(
          #{config.root}/lib/
          #{config.root}/app/sweepers
          #{config.root}/app/observers
          #{config.root}/app/presenters
          #{config.root}/app/pdfs
          #{config.root}/app/models/concerns
    )
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    
    # Activate observers that should always be running.
    Dir.chdir("#{Rails.root}/app/observers") do
      config.active_record.observers = Dir["*_observer.rb"].collect {|ob_name| ob_name.split(".").first }
    end
    
    # Remove Timestamps from migrations and use version numbers
    # config.active_record.timestamped_migrations = false

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Eastern Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # Added to load the international Files by folder name - streamlined into subfolders
    #config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    #config.i18n.default_locale = :es

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :password_confirmation]
    
    # Allows Devise to use the UrlHelper file for Subdomain links in the emails.
    config.to_prepare do
      Devise::Mailer.class_eval do 
        helper :url
      end
    end
    
  end
end
