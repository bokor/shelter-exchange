# CarrierWave Fog Connection
#----------------------------------------------------------------------------
require 'carrierwave/orm/activerecord'
require 'carrierwave/processing/mime_types'

CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider => 'AWS',
    :aws_access_key_id => ShelterExchange.settings.aws_access_key_id,
    :aws_secret_access_key => ShelterExchange.settings.aws_secret_access_key
  }
  config.fog_directory  = ShelterExchange.settings.s3_bucket
  config.fog_attributes = {
    'Cache-Control' => 'max-age=315576000',
    'Expires' => 1.year.from_now.httpdate
  }
  config.fog_public = true
end

