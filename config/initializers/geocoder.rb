Geocoder.configure do |config|

  config.timeout   = 3    
  config.language  = :en         
  
  config.lookup    = :google

  config.units     = :mi       
  config.distances = :spherical
end
