source "https://rubygems.org"

gem "rails", "3.2.12"

gem "rack"
gem "rake"
gem "mail"

gem "pry-rails"

# Database
#----------------------------------------------------------------------------
gem "mysql2"
gem "seedbank"

# Zip Files
#----------------------------------------------------------------------------
gem "rubyzip"
gem "zippy"

# Login - Authentication - Authorization
#----------------------------------------------------------------------------
gem "devise"
gem "devise_invitable"
gem "cancan"

# UI/UX - HTML/JS/CSS/PDF
#----------------------------------------------------------------------------
gem "will_paginate"
gem "jquery-rails"
gem "prawn"

group :assets do
  gem "sass-rails"
  gem "coffee-rails"
  gem "uglifier"
  gem "yui-compressor"
  gem "asset_sync"
  #gem "turbo-sprockets-rails3"
end

group :development, :test do
  gem 'quiet_assets'
end

# Images
#----------------------------------------------------------------------------
gem "carrierwave"
gem "mini_magick"

# Helpers
#----------------------------------------------------------------------------
gem "rinku", :require => "rails_rinku" # Rails 3.2 auto_link

# APIs
#----------------------------------------------------------------------------
gem "rest-client"
gem "fog"

# Maps - Geocoding
#----------------------------------------------------------------------------
gem "geocoder"

# Scheduled and Delayed Jobs - Asyc Transactions
#----------------------------------------------------------------------------
gem "daemons"
gem "delayed_job_active_record"

# Performance
#----------------------------------------------------------------------------
gem "dalli"

# Monitoring & Notification
#----------------------------------------------------------------------------
gem "airbrake"

# Local Testing and Tools
#----------------------------------------------------------------------------
group :development do
  gem "thin"
  gem "foreman"
  gem "engineyard"
end

group :development, :test do
  gem "rspec-rails"
  gem "debugger", :platforms => :ruby_19
  #gem "parallel_tests"
end

group :test do
  gem "factory_girl_rails"
  gem "factory_girl_extensions"
  gem "capybara"
  # gem "capybara-webkit"
  gem "capybara-email"
  gem "launchy"
  gem "database_cleaner"
  #gem "artifice"
end

