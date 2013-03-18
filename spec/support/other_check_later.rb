# JSON and JSONP Testing
#module MockServerHelper

  ## These two functions should get put the support folder
  #def start_mock_server(port, &app)
    #server = Puma::Server.new app
    #server.add_tcp_listener '127.0.0.1', port
    #server.run
    #server
  #end

  ## stolen from capybara
  #def find_available_port
    #server = TCPServer.new('127.0.0.1', 0)
    #server.addr[1]
  #ensure
    #server.close if server
  #end
#end

# CarrierWave
# CarrierWave.configure do |config|
  #config.storage = :file
#end


# CapybaraHelper
# module CapybaraHelper

  #def should_see options={}
    #if options[:css]
      #page.should have_css(options[:css])
      #js("jQuery('#{options[:css]}:visible').length").should > 0
    #end
  #end

  #def should_be_on expected_path
    #current_path.should == expected_path
  #end

  #def check_table_values_for table_selector, expected_table_values
    #all( "#{ table_selector } tbody tr" ).each do |row|
      #row_values = expected_table_values.shift
      #row.all( 'td' ).each do |cell|
        #cell.should have_content( row_values.shift )
      #end
    #end
  #end

  #def js script
    #require_javascript_support!
    #page.evaluate_script script
  #end

  #def coffee(script)
    #require_javascript_support!
    #page.evaluate_coffeescript script
  #end

  #def click *args
    #find(*args).click
  #end

  #def send_keys *args
    #require_selenium_support!
    #options = args.extract_options!
    #element = options[:to] ? find(options[:to]).native : active_element
    #element.send_keys(*args)
  #end

  #alias :press      :send_keys # ie. press :tab
  #alias :enter_text :send_keys # ie. enter_text 'Awesome!'

  #def active_element
    #js 'document.activeElement'
  #end

  #def take_and_open_screenshot!
    #require_selenium_support!
    #`open #{take_screenshot!}`
  #end

  #def take_screenshot!
    #require_selenium_support!
    #mkdir_p screenshots_path
    #screenshot_file = "#{screenshots_path}/#{screenshot_filename}"
    #page.driver.browser.save_screenshot screenshot_file
    #screenshot_file
  #end

  #def screenshots_path
    #Rails.root.join 'tmp', 'screenshots'
  #end

  #def screenshot_filename
    #"#{Time.now.strftime '%Y%m%d%I%M%s'}.png"
  #end

  #def require_javascript_support!
    #raise 'this helper requires javascript support to be enabled' if Capybara.current_driver == :rack_test
  #end

  #def require_selenium_support!
    #unless Capybara.current_driver.to_s.start_with? 'selenium'
      #raise 'this helper requires selenium support to be enabled'
    #end
  #end

  #def accept_confirmation
    #require_selenium_support!
    #sleep 0.1 if page.driver.browser.browser == :chrome
    #page.driver.browser.switch_to.alert.accept
  #end

  #def alert_text
    #require_selenium_support!
    #sleep 0.1 if page.driver.browser.browser == :chrome
    #page.driver.browser.switch_to.alert.text
  #end

  #def reject_confirmation
    #require_selenium_support!
    #sleep 0.1 if page.driver.browser.browser == :chrome
    #page.driver.browser.switch_to.alert.dismiss
  #end

  #def mouse_over element
    #require_selenium_support!
    #element = find(element) if String === element
    #page.driver.browser.mouse.move_to element.native
  #end

  #def soap
    #save_and_open_page
  #end

  #alias :saop :soap
#end

# Artifice Helper
#module ArtificeHelper

  #def responder options={}

    #options = {
      #:status  => 200,
      #:body    => '',
      #:headers => {
        #'Content-Type' => 'application/json'
      #}
    #}.merge! options

    #lambda { |env|
      #[ options[:status], options[:headers], options[:body] ]
    #}
  #end

  #def with_standard_responses
    #Artifice.activate_with @standard_responder do
      #yield
    #end
  #end

  #def with_bad_domain
    #Artifice.deactivate # <-- Need to remove artifice to stub Net::HTTP directly

    #[ Net::HTTP, Mechanize ].each do |klass|
      #klass.class_eval do
        #alias :old_get :get
        #def get *args
          #raise SocketError.new 'getaddrinfo: nodename nor servname provided, or not known'
        #end
      #end
    #end

    #yield

    #[ Net::HTTP, Mechanize ].each do |klass|
      #klass.class_eval do
        #alias :get :old_get
      #end
    #end
  #end

  #def caught_requests= value
    #@caught_requests = value
  #end

  #def caught_requests
    #@caught_requests ||= []
  #end

  #def clear_caught_requests!
    #@caught_requests = []
  #end
#end

# these are needed or else capybara does not work nicely with artifice
#module Selenium
  #Net = ::Net.dup
  #module Net
    #silence_warnings do
      #HTTP = Artifice::NET_HTTP
    #end
  #end
#end

#class Capybara::Server
  #Net = ::Net.dup
  #module Net
    #silence_warnings do
      #HTTP = Artifice::NET_HTTP
    #end
  #end
#end

