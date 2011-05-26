# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Shelterexchange::Application.initialize!


# Makes the errors blank
ActionView::Base.field_error_proc = proc { |input, instance| input }
