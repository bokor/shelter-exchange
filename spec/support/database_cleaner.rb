require "database_cleaner"

RSpec.configure do |config|

  config.before :each do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
  end
end

  #config.before :each do
    #if Capybara.current_driver == :rack_test
      #DatabaseCleaner.strategy = :transaction
      #DatabaseCleaner.start
    #else
      #DatabaseCleaner.strategy = :truncation, { :except => %w[animal_types animal_statuses breeds] }
    #end
  #end

  #config.before :each do
    #if example.metadata[:js] || example.metadata[:truncation]
      #strategy = :truncation
    #else
      #strategy = :transaction
    #end

    #DatabaseCleaner.strategy = strategy
    #DatabaseCleaner.start
  #end

