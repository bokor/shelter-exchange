source "https://rubygems.org"

gem "rails", "3.2.15"

gem "rack"
gem "rake"
gem "mail"

# Database
#----------------------------------------------------------------------------
gem "mysql2"
gem "seedbank", "0.3.0.pre"

# JSON
#----------------------------------------------------------------------------
gem "oj"
gem "json_builder"

# APIs
#----------------------------------------------------------------------------
gem "fog"

# Zip Files
#----------------------------------------------------------------------------
gem "zipruby"

# Login - Authentication - Authorization
#----------------------------------------------------------------------------
gem "devise"
gem "devise_invitable"
gem "cancan"

# UI/UX - HTML/JS/CSS/PDF
#----------------------------------------------------------------------------
gem "will_paginate"
gem "jquery-rails"
gem "sitemap_generator"

group :assets do
  gem "sass-rails"
  gem "coffee-rails"
  gem "uglifier"
  gem "yui-compressor"
  gem "asset_sync"
end

# Images
#----------------------------------------------------------------------------
gem "carrierwave"
gem "mini_magick"

# Helpers
#----------------------------------------------------------------------------
gem "rinku", :require => "rails_rinku" # Rails 3.2 auto_link

# Maps - Geocoding
#----------------------------------------------------------------------------
gem "geocoder"

# Scheduled and Delayed Jobs - Asyc Transactions
#----------------------------------------------------------------------------
gem "daemons"
gem "delayed_job_active_record"
gem "whenever", :require => false

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
  gem 'quiet_assets'
end

group :development, :test do
  gem "pry-rails"
  gem "rspec-rails"
  gem "debugger", :platforms => :ruby_19
end

group :test do
  gem "factory_girl_rails"
  gem "factory_girl_extensions"
  gem "capybara"
  gem "capybara-email"
  gem "database_cleaner"
  gem "vcr"
  gem "webmock"
  gem "fake_ftp"
  gem "timecop"
end

