source 'http://rubygems.org'

gem 'rails', '3.2.9'
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

# Local Testing and Tools
#----------------------------------------------------------------------------
group :test, :development do
  gem 'thin'    
  gem 'foreman'
end

group :development, :test do
  gem 'engineyard'
end

# Monitoring & Notification
#----------------------------------------------------------------------------
gem 'hoptoad_notifier'


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
        # group :test, :development do
          # gem 'debugger', :platforms => :ruby_19
          # gem 'rspec-rails' # Development group should have rspec-rails so that you get the rake tasks
        # end
        # gem 'aws-ses', '0.4.3'
        # gem 'geokit-rails3', '0.1.3'        # Geocoding
        # gem 'mime-types',      :require => 'mime/types'


        # Factory girl needs to be test only or else database rake tasks fail
        # when your database has no tables.
        # group :test do
        #   gem 'factory_girl_rails', '1.7.0' # upgrade from this when we can be bothered using the new factory_girl syntax
        #   gem 'factory_girl_extensions'

        #   # XXX: We must use a branch of artifice which supports getting parameters which are streamed as part of a POST
        #   #   request. Artifice by default will return an empty hash when trying to get parameters of a multipart POST
        #   #   request. In these cases, one might think that the params are stored in the streaming body. However,
        #   #   `request.body.read` returns an empty string in these cases. There is one other way in which one might try
        #   #   to access parameters from a multipart POST request: `request.send(:parse_multipart, request.env)` but this
        #   #   raises with the message "bad request".
        #   gem 'artifice',      :git => 'git://github.com/wildfireapp/artifice.git', :branch => 'streaming_requests'
        #   gem 'capybara'
        #   gem 'puma', '~> 1.5.0' # bumping to 1.6 seems to make some tests fail
        #   gem 'capybara-email'
        #   gem 'database_cleaner'
        #   gem 'launchy'
        #   gem 'sinatra',       :require => 'sinatra/base'
        # end

        # group :production do
        #   gem 'SyslogLogger'
        # end

