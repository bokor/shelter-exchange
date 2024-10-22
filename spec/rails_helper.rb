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

  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = false

  # Matchers and Helpers
  config.include Capybara::DSL
  config.include Capybara::Email::DSL
  config.include Capybara::RSpecMatchers
  config.include FactoryGirl::Syntax::Methods
  config.include Devise::TestHelpers, :type => :controller
  config.include Warden::Test::Helpers, :type => :feature
  config.include CarrierWave::Test::Matchers
  config.include ActionController::RecordIdentifier, :type => :feature

  # Custom RSpec Extensions
  config.extend Authentication::Controller, :type => :controller
  config.extend Authentication::Feature, :type => :feature

  # Custom Helper Files
  config.include CapybaraHelper, :type => :feature
  config.include MailerHelper, :type => :feature

  config.before :each do
    # Remove later when Type and Status are moved to just lib or model rather than db
    allow_message_expectations_on_nil

    # Clear out Mailers
    ActionMailer::Base.deliveries = []
  end

  config.after :suite do
    # Remove Carrierwave Files
    FileUtils.rm_rf(Dir["#{Rails.root}/public/uploads"])
  end

  config.after :each do
    # Resets time for freezes and allows for sloppy code
    Timecop.return
  end
end

