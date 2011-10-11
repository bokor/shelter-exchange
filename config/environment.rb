# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
ShelterExchangeApp::Application.initialize!


# Makes the errors blank
ActionView::Base.field_error_proc = proc { |input, instance| input }

ENV["RAILS_ASSET_ID"]=Time.now.to_time.i
