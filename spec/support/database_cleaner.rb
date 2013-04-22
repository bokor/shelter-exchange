require "database_cleaner"

RSpec.configure do |config|

  config.before :each do
    if example.metadata[:js] || example.metadata[:truncation]
      strategy = :truncation
    else
      strategy = :transaction
    end
    DatabaseCleaner.strategy = strategy
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
  end

  config.after :suite do
    DatabaseCleaner.clean_with(:truncation)
  end
end

