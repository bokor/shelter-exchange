require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir     = "spec/cassettes"
  config.ignore_localhost         = true
  config.default_cassette_options = {
    :serialize_with    => :json #,
    #:record            => :once #, :new_episodes,
    #:match_requests_on => [:host]
  }
  config.hook_into :webmock
  config.configure_rspec_metadata!
end

#, :vcr => { :cassette_name => "app/shelter/google_maps" }

