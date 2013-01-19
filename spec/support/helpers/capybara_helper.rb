# class Capybara::Session
#   def execute_coffeescript(script)
#     execute_script CoffeeScript.compile(script, :bare => true)
#   end

#   def evaluate_coffeescript(script)
#     evaluate_script CoffeeScript.compile(script, :bare => true).gsub(/;$/, '').strip
#   end
# end

module CapybaraHelper

#   def should_see options={}
#     if options[:css]
#       page.should have_css(options[:css])
#       js("jQuery('#{options[:css]}:visible').length").should > 0
#     end
#   end

  # def should_be_on expected_path
  #   current_path.should == expected_path
  # end

#   def check_table_values_for table_selector, expected_table_values
#     all( "#{ table_selector } tbody tr" ).each do |row|
#       row_values = expected_table_values.shift
#       row.all( 'td' ).each do |cell|
#         cell.should have_content( row_values.shift )
#       end
#     end
#   end

#   def js script
#     require_javascript_support!
#     page.evaluate_script script
#   end

#   def coffee(script)
#     require_javascript_support!
#     page.evaluate_coffeescript script
#   end

#   def pending_xhr_count
#     js 'jQuery.active'
#   end

#   def wait_for_ajax! wait_time=Capybara.default_wait_time
#     page.wait_until wait_time do
#       pending_xhr_count == 0
#     end
#   end

#   def click *args
#     find(*args).click
#   end

#   def send_keys *args
#     require_selenium_support!
#     options = args.extract_options!
#     element = options[:to] ? find(options[:to]).native : active_element
#     element.send_keys *args
#   end

#   alias :press      :send_keys # ie. press :tab
#   alias :enter_text :send_keys # ie. enter_text 'Awesome!'

#   def active_element
#     js 'document.activeElement'
#   end

#   def take_and_open_screenshot!
#     require_selenium_support!
#     `open #{take_screenshot!}`
#   end

#   def take_screenshot!
#     require_selenium_support!
#     mkdir_p screenshots_path
#     screenshot_file = "#{screenshots_path}/#{screenshot_filename}"
#     page.driver.browser.save_screenshot screenshot_file
#     screenshot_file
#   end

#   def screenshots_path
#     Rails.root.join 'tmp', 'screenshots'
#   end

#   def screenshot_filename
#     "#{Time.now.strftime '%Y%m%d%I%M%s'}.png"
#   end

#   def require_javascript_support!
#     raise 'this helper requires javascript support to be enabled' if Capybara.current_driver == :rack_test
#   end

#   def require_selenium_support!
#     unless Capybara.current_driver.to_s.start_with? 'selenium'
#       raise 'this helper requires selenium support to be enabled'
#     end
#   end

#   def accept_confirmation
#     require_selenium_support!
#     sleep 0.1 if page.driver.browser.browser == :chrome
#     page.driver.browser.switch_to.alert.accept
#   end

#   def alert_text
#     require_selenium_support!
#     sleep 0.1 if page.driver.browser.browser == :chrome
#     page.driver.browser.switch_to.alert.text
#   end

#   def reject_confirmation
#     require_selenium_support!
#     sleep 0.1 if page.driver.browser.browser == :chrome
#     page.driver.browser.switch_to.alert.dismiss
#   end

#   def mouse_over element
#     require_selenium_support!
#     element = find(element) if String === element
#     page.driver.browser.mouse.move_to element.native
#   end

#   def soap
#     save_and_open_page
#   end

#   alias :saop :soap
end