require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir     = "spec/cassettes"
  config.ignore_localhost         = true
  config.default_cassette_options = {
    :serialize_with    => :json,
    :record            => :new_episodes
  }
  config.hook_into :webmock
  config.configure_rspec_metadata!
end

# On request spec
#, :vcr => { :cassette_name => "app/shelter/google_maps" }

