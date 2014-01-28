ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)

require "rspec/rails"
require "capybara/rspec"
require "capybara/rails"
require "capybara/email/rspec"
require "webmock/rspec"

Dir[Rails.root.join("spec/support/**/*.rb")].each {|s| require s }
Dir[Rails.root.join("spec/shared_examples/**/*.rb")].each {|s| require s }

RSpec.configure do |config|
  config.mock_with :rspec

  config.use_transactional_fixtures = false
  config.treat_symbols_as_metadata_keys_with_true_values = true

 # config.expect_with :rspec do |c|
 #    c.syntax = :expect
 #  end

  # Matchers and Helpers
  config.include Capybara::DSL
  config.include Capybara::Email::DSL
  config.include Capybara::RSpecMatchers
  config.include FactoryGirl::Syntax::Methods
  config.include Devise::TestHelpers, :type => :controller
  config.include Warden::Test::Helpers, :type => :request
  config.include CarrierWave::Test::Matchers
  config.include ActionController::RecordIdentifier, :type => :request

  # Custom RSpec Extensions
  config.extend Authentication::Controller, :type => :controller
  config.extend Authentication::Request, :type => :request

  # Custom Helper Files
  config.include CapybaraHelper, :type => :request

  config.before :suite do
    # Disable All Observers
    ActiveRecord::Base.observers.disable :all
  end

  config.after :suite do
    # Remove Carrierwave Files
    FileUtils.rm_rf(Dir["#{Rails.root}/public/uploads"])
  end
end

