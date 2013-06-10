Geocoder.configure(:lookup => :test)

Geocoder::Lookup::Test.set_default_stub \
  [
    {
      "latitude"     => 37.769929,
      "longitude"    => -122.446682,
      "address"      => "San Francisco, CA, USA",
      "state"        => "San Francisco",
      "state_code"   => "CA",
      "country"      => "United States",
      "country_code" => "US"
    }
  ]

