require 'shelter_exchange/extensions/validators/breed_validator'
require 'shelter_exchange/extensions/validators/date_format_validator'
require 'shelter_exchange/extensions/validators/email_format_validator'
require 'shelter_exchange/extensions/validators/phone_format_validator'
require 'shelter_exchange/extensions/validators/subdomain_format_validator'
require 'shelter_exchange/extensions/validators/twitter_format_validator'
require 'shelter_exchange/extensions/validators/url_format_validator'
require 'shelter_exchange/extensions/validators/video_url_format_validator'

# Dir["#{File.dirname(__FILE__)}/validators/*.rb"].sort.each do |path|
#   require "shelter_exchange/validators/#{File.basename(path, '.rb')}"
# end