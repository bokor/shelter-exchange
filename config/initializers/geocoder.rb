Geocoder.configure do |config|

  config.timeout      = 3    
  config.language     = :en         
  
  config.lookup       = :google     
  config.api_key      = 'ABQIAAAAg9xsqgYJxaHo-DnBFgP6xhSRwpAYaW0U93K_zUrZiGqT-ciXVBQLWJyiXGkZsV-QDMvRpi9RTFTY2Q'

  ## Calculation options
  config.units     = :mi       
  config.distances = :spherical   
end

# Geokit::Geocoders::yahoo = 'uGLVBTvV34HXr25f62cUvOHMcisHVXwJx_34GYBs4Jg_gOssOTZd26AaIcrw9jmFNNY-'