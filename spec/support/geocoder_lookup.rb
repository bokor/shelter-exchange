RSpec.configure do |config|

  config.before :suite do
    Geocoder.configure(:lookup => :test)

    #TODO: Use Artifice, Fakeweb or VCR to mock the web calls
    Geocoder::Lookup::Test.set_default_stub(
      [
        {
          'latitude'     => 40.7143528,
          'longitude'    => -74.0059731,
          'address'      => 'New York, NY, USA',
          'state'        => 'New York',
          'state_code'   => 'NY',
          'country'      => 'United States',
          'country_code' => 'US'
        }
      ]
    )
  end
end



