# Register Firefox with Capybara
Capybara.register_driver :firefox do |app|
  driver = Capybara::Selenium::Driver.new(app, :browser => :firefox)
  driver.browser.manage.window.resize_to 1200, 1200 # (width, height) wide enough to view the whole layout
  driver
end

# Configure Capybara
Capybara.configure do |config|
  config.default_selector    = :css
  config.current_driver      = :rack_test
  config.javascript_driver   = :firefox
  config.default_wait_time   = 5

  # Support for Rspec / Capybara subdomain integration testing
  config.default_host = Rails.application.routes.default_url_options[:host]
  config.server_port  = Rails.application.routes.default_url_options[:port]
  config.app_host     = "http://www.#{Capybara.default_host}:#{Capybara.server_port}"
end

def switch_to_subdomain(subdomain)
  Capybara.app_host = "http://#{subdomain}.#{Capybara.default_host}:#{Capybara.server_port}"
end

