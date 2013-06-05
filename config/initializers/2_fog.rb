# Reusable Fog Connection
#----------------------------------------------------------------------------
Fog.mock! if Rails.env.test? # Mocking the connection for test environment

FOG_STORAGE ||= Fog::Storage.new({
  :provider              => 'AWS',
  :aws_access_key_id     => S3_ACCESS_KEY_ID,
  :aws_secret_access_key => S3_SECRET_ACCESS_KEY
})

# Creating a Test bucket for test environment
if Rails.env.test?
  FOG_STORAGE.directories.create(:key => S3_BUCKET)
end

FOG_BUCKET ||= FOG_STORAGE.directories.get(S3_BUCKET)

