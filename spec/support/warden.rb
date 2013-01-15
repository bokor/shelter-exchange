RSpec.configure do |config|
  
  config.before :suite do
    Warden.test_mode!
  end

  config.after :each do  
    Warden.test_reset!
    Capybara.reset_sessions!
  end 
end