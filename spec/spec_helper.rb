ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)

# require "rake"
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
  config.treat_symbols_as_metadata_keys_with_true_values = true # in RSpec 3 this will no longer be necessary.

  # Matchers and Helpers
  config.include ActionController::RecordIdentifier, :type => :request
  config.include Capybara::DSL
  config.include Capybara::Email::DSL
  config.include Capybara::RSpecMatchers
  config.include FactoryGirl::Syntax::Methods
  config.include Rack::Test::Methods
  config.include Devise::TestHelpers, :type => :controller
  config.include Warden::Test::Helpers
  config.include CarrierWave::Test::Matchers

  # Custom Helper Files
  config.include CapybaraHelper, :type => :request
  config.include AccountHelper, :type => :request

  config.before :suite do
    # Load Seed Data
    # require rake, transactional fixures true, enabled shared connnection, remove database cleaner
    # ShelterExchangeApp::Application.load_tasks
    # Rake::Task["db:seed:common"].invoke

    # Disable All Observers
    ActiveRecord::Base.observers.disable :all
  end

  config.after :suite do
    # Remove Carrierwave Files
    FileUtils.rm_rf(Dir["#{Rails.root}/public/uploads"])
  end
end

