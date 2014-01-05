if defined?(AssetSync)
  AssetSync.configure do |config|
    config.fog_provider          = 'AWS'
    config.aws_access_key_id     = ShelterExchange.settings.aws_access_key_id
    config.aws_secret_access_key = ShelterExchange.settings.aws_secret_access_key
    config.fog_directory         = ShelterExchange.settings.s3_bucket
    config.gzip_compression      = true
    config.manifest              = false
  end
end

