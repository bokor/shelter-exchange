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

if Rails.env.test?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
end

