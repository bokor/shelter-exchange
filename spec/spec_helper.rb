ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)

require "rspec/rails"
require "capybara/rspec"
require "capybara/rails"
require "capybara/email/rspec"

Dir[Rails.root.join("spec/support/**/*.rb")].each {|s| require s }

RSpec.configure do |config|
  config.mock_with :rspec

  config.use_transactional_fixtures = true # see shared_connections.rb
  config.infer_base_class_for_anonymous_controllers = false

  config.include Capybara::DSL
  config.include Capybara::Email::DSL
  config.include Capybara::RSpecMatchers
  config.include FactoryGirl::Syntax::Methods
  config.include Rack::Test::Methods
  config.include Devise::TestHelpers, :type => :controller
  config.include Warden::Test::Helpers

  # Helper Files
  config.include CapybaraHelper, :type => :request
  config.include AccountHelper, :type => :request
end
