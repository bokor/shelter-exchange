RSpec.configure do |config|

  config.after :each do
    # Clear out any email from previous tests
    ActionMailer::Base.deliveries.clear
  end
end