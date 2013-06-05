# Support for Rspec / Capybara subdomain integration testing
# Make sure this file is required by spec_helper.rb
#
# Sample subdomain test:
# it "should test subdomain" do
#   switch_to_subdomain("mysubdomain")
#   visit root_path
# end

DEFAULT_DOMAIN = Rails.application.routes.default_url_options[:host]
# DEFAULT_PORT   = Rails.application.routes.default_url_options[:port]

RSpec.configure do |config|
  Capybara.default_host = "#{DEFAULT_DOMAIN}"
  # Capybara.server_port = DEFAULT_PORT
  Capybara.app_host = "http://www.#{DEFAULT_DOMAIN}" #:#{DEFAULT_PORT}"
end

def switch_to_subdomain(subdomain)
  Capybara.app_host = "http://#{subdomain}.#{DEFAULT_DOMAIN}" #:#{DEFAULT_PORT}"
end
