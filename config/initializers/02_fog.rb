# Reusable Fog Connection
#----------------------------------------------------------------------------
Fog.mock! if Rails.env.test? # Mocking the connection for test environment
Fog.timeout = 2400

FOG_CONNECTION = Fog::Storage.new({
  :provider              => 'AWS',
  :aws_access_key_id     => ShelterExchange.settings.aws_access_key_id,
  :aws_secret_access_key => ShelterExchange.settings.aws_secret_access_key
})

# Creating a Test bucket for test environment
if Rails.env.test?
  FOG_CONNECTION.directories.create(:key => ShelterExchange.settings.s3_bucket)
end

FOG_BUCKET = FOG_CONNECTION.directories.get(ShelterExchange.settings.s3_bucket) rescue nil

