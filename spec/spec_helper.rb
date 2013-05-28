ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)

require "rspec/rails"
require "capybara/rspec"
require "capybara/rails"
require "capybara/email/rspec"

Dir[Rails.root.join("spec/support/**/*.rb")].each {|s| require s }

RSpec.configure do |config|
  config.mock_with :rspec

  config.use_transactional_fixtures = false

  config.include ActionController::RecordIdentifier, :type => :request

  config.include Capybara::DSL
  config.include Capybara::Email::DSL
  config.include Capybara::RSpecMatchers
  config.include FactoryGirl::Syntax::Methods
  config.include Rack::Test::Methods
  config.include Devise::TestHelpers, :type => :controller
  config.include Warden::Test::Helpers
  config.include CarrierWave::Test::Matchers

  # Helper Files
  config.include CapybaraHelper, :type => :request
  config.include AccountHelper, :type => :request

  # config.before :suite do
  #   Delayed::Worker.delay_jobs = false
  # end
end

