# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Shelterexchange::Application.initialize!

# ActionView::Base.field_error_proc = Proc.new do |html_tag, instance_tag|
#   "#{html_tag}".html_safe # Makes the errors blank
# end

ActionView::Base.field_error_proc = proc { |input, instance| input }
# ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
#   :default => "%m/%d/%Y",
#   :date_time12  => "%m/%d/%Y %I:%M%p",
#   :date_time24  => "%m/%d/%Y %H:%M",
#   :current_year  => Time.now.year,
# )