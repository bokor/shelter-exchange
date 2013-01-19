require "yaml"
#http://www.engineyard.com/blog/2011/mocking-fog-when-using-it-with-carrierwave/

# S3 Credentials
#----------------------------------------------------------------------------
S3_CREDENTIALS = YAML.load_file(Rails.root.join("config/fog_credentials.yml"))

S3_BUCKET            = S3_CREDENTIALS[Rails.env]["bucket"] 
S3_ACCESS_KEY_ID     = S3_CREDENTIALS[Rails.env]["access_key_id"] 
S3_SECRET_ACCESS_KEY = S3_CREDENTIALS[Rails.env]["secret_access_key"] 


# Reusable Fog Connection
#----------------------------------------------------------------------------
Fog.mock! if Rails.env.test? # Mocking the connection for test environment

FOG_STORAGE ||= Fog::Storage.new({
  :provider => 'AWS', 
  :aws_access_key_id => S3_ACCESS_KEY_ID,
  :aws_secret_access_key => S3_SECRET_ACCESS_KEY
})

# Creating a Test bucket for test environment
if Rails.env.test? 
  FOG_STORAGE.directories.create(:key => S3_BUCKET) 
end

FOG_BUCKET ||= FOG_STORAGE.directories.get(S3_BUCKET)


# CarrierWave Fog Connection
#----------------------------------------------------------------------------
require 'carrierwave/orm/activerecord'
require 'carrierwave/processing/mime_types'

CarrierWave.configure do |config|
  config.fog_credentials = { 
    :provider => 'AWS',
    :aws_access_key_id => S3_ACCESS_KEY_ID, 
    :aws_secret_access_key => S3_SECRET_ACCESS_KEY 
  }
  config.fog_directory  = S3_BUCKET
  config.fog_attributes = {
    'Cache-Control' => 'max-age=315576000',
    'Expires' => 1.year.from_now.httpdate
  } 
  config.fog_public = true
end
