# Register Firefox with Capybara
Capybara.register_driver :firefox do |app|
  driver = Capybara::Selenium::Driver.new(app, :browser => :firefox)
  driver.browser.manage.window.resize_to 1200, 1200 # (width, height) wide enough to view the whole layout
  driver
end

# Register Chrome with Capybara
Capybara.register_driver :chrome do |app|
  # To get chrome working with selenium on the mac, run 'brew install chromedriver'
  driver = Capybara::Selenium::Driver.new app, :browser => :chrome
  driver.browser.manage.window.resize_to 1200, 1200 # (width, height) wide enough to view the whole layout
  driver
end

# Configure Capybara
Capybara.configure do |config|
  config.default_selector  = :css
  config.current_driver    = :rack_test
  config.javascript_driver = :webkit
  config.default_wait_time = 5
end
