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

# class ActiveRecord::Base
#   mattr_accessor :shared_connection
#   @@shared_connection = nil
#
#   def self.connection
#     @@shared_connection || retrieve_connection
#   end
# end
#
# # Forces all threads to share the same connection. This works on
# # Capybara because it starts the web server in a thread.
# ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

