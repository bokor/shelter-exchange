require 'database_cleaner'

# RSpec.configure do |config|

#   config.before :each do |spec|
#     if spec.metadata[:js] || spec.metadata[:truncation]
#       strategy = :truncation
#     else
#       strategy = :transaction
#     end
#     DatabaseCleaner.strategy = strategy
#     DatabaseCleaner.start
#   end

#   config.after :each do
#     DatabaseCleaner.clean
#   end

#   config.after :suite do
#     DatabaseCleaner.clean_with(:truncation)
#   end
# end

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # rspec-rails 3 will no longer automatically infer an example group's spec type
  # from the file location. You can explicitly opt-in to the feature using this
  # config option.
  # To explicitly tag specs without using automatic inference, set the `:type`
  # metadata manually:
  #
  #     describe ThingsController, :type => :controller do
  #       # Equivalent to being in spec/controllers
  #     end
  config.infer_spec_type_from_file_location!
end

