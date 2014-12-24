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
end

