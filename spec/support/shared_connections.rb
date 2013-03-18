# Use shared connection with transactional fixtures
# http://blog.plataformatec.com.br/2011/12/three-tips-to-improve-the-performance-of-your-test-suite/
#
# Finally, if any part of your code is using threads to access the database and you need to
# test it, you can just set ActiveRecord::Base.shared_connection = nil during that specific
# test and everything should work great!
#----------------------------------------------------------------------------
class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil


  def self.connection
    @@shared_connection || retrieve_connection
  end
end

# Forces all threads to share the same connection. This works on
# Capybara because it starts the web server in a thread.
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
