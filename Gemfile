source 'http://rubygems.org'

gem 'rails', '3.2.11'

gem 'rack'
gem 'rake'
gem 'mail'
gem 'pry-rails'

# Database
#----------------------------------------------------------------------------
gem 'mysql2'

# Zip Files
#----------------------------------------------------------------------------
gem 'rubyzip'
gem 'zippy'            

# Login - Authentication - Authorization
#----------------------------------------------------------------------------
gem 'devise'               
gem 'devise_invitable' 
gem 'cancan'               

# UI/UX - HTML/JS/CSS/PDF
#----------------------------------------------------------------------------
gem 'will_paginate'
gem 'jquery-rails'
gem 'jammit'
gem 'jammit-s3'
gem 'prawn'

# Images
#----------------------------------------------------------------------------         
gem 'carrierwave'
gem 'mini_magick'

# Helpers
#----------------------------------------------------------------------------
gem 'rinku', :require => 'rails_rinku' # Rails 3.2 auto_link 

# APIs
#----------------------------------------------------------------------------
gem 'rest-client'
gem 'fog'
gem 'twitter'
gem 'googl'   

# Maps - Geocoding
#----------------------------------------------------------------------------
gem 'geocoder'

# Scheduled and Delayed Jobs - Asyc Transactions
#----------------------------------------------------------------------------
gem 'delayed_job_active_record'  # Change to RESQUE

# Performance
#----------------------------------------------------------------------------
gem 'dalli'

# Monitoring & Notification
#----------------------------------------------------------------------------
gem 'airbrake'

# Local Testing and Tools
#----------------------------------------------------------------------------
group :development, :test do
  gem 'thin'    
  gem 'foreman'
  gem 'engineyard'

  gem 'rspec-rails'
  gem 'debugger', :platforms => :ruby_19
end

group :test do
  gem 'factory_girl_rails'
  gem 'factory_girl_extensions'
  gem 'capybara'
  gem 'launchy' 

  # gem 'capybara-email' or 'email-spec' 
end






# Investigate later
#----------------------------------------------------------------------------

# TODO
          # Gems used only for assets and not required
          # in production environments by default.
          # group :assets do
          #   gem 'sass-rails',   '~> 3.2.3'
          #   gem 'coffee-rails', '~> 3.2.1'

          #   # See https://github.com/sstephenson/execjs#readme for more supported runtimes
          #   # gem 'therubyracer', :platforms => :ruby

          #   gem 'uglifier', '>= 1.0.3'
          #   gem 'yui-compressor'
          # end

          # MESSENGER
          # asset pipeline
          # gem 'yui-compressor' # compress CSS
          # gem 'coffee-filter' # coffeescript haml filter
          # gem 'therubyracer' # needed to run coffeescript on ubuntu
          # the ui-toolkit includes the following:
          #gem 'haml-rails'
          #gem 'sass-rails'
          #gem 'coffee-rails'
          #gem 'uglifier'



        # gem 'puma', '~> 1.5.0' # bumping to 1.6 seems to make some tests fail


        # group :production do
        #   gem 'SyslogLogger'
        # end

