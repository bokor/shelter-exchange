ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)

require "rspec/rails"
require "capybara/rspec"
require "capybara/rails"
require "capybara/email/rspec"
require "webmock/rspec"

Dir[Rails.root.join("spec/support/**/*.rb")].each {|s| require s }

RSpec.configure do |config|
  config.mock_with :rspec

  config.use_transactional_fixtures                      = false
  config.treat_symbols_as_metadata_keys_with_true_values = true # in RSpec 3 this will no longer be necessary.

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
end

