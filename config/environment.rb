# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
ShelterExchangeApp::Application.initialize!


# Makes the errors blank
ActionView::Base.field_error_proc = proc { |input, instance| input }

# Added to support s3 cache control
require "aws/s3"
require "s3_cache_control"
