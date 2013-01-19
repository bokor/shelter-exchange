RSpec.configure do |config|

  config.after :each do
    # Clear cache after each test runs
    Rails.cache.clear
  end
end