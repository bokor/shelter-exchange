# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)

require 'rspec/rails'

# Add this to load Capybara integration:
require 'capybara/rspec'
require 'capybara/rails'

# RSpec Specific Configuration 
Dir[Rails.root.join("spec/support/**/*.rb")].each {|s| require s }

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = false

  # Makes Capybara load correctly
  config.include Capybara::DSL
  config.include Capybara::RSpecMatchers

  # Include Helper Files
  config.include CapybaraHelper, :type => :request
end
