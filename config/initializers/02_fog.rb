# Reusable Fog Connection
#----------------------------------------------------------------------------
Fog.mock! if Rails.env.test? # Mocking the connection for test environment

FOG_STORAGE ||= Fog::Storage.new({
  :provider              => 'AWS',
  :aws_access_key_id     => ShelterExchange.settings.aws_access_key_id,
  :aws_secret_access_key => ShelterExchange.settings.aws_secret_access_key
})

# Creating a Test bucket for test environment
if Rails.env.test?
  FOG_STORAGE.directories.create(:key => ShelterExchange.settings.s3_bucket)
end

FOG_BUCKET ||= FOG_STORAGE.directories.get(ShelterExchange.settings.s3_bucket)

