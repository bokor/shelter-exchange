AssetSync.configure do |config|
  config.fog_provider          = 'AWS'
  config.aws_access_key_id     = S3_ACCESS_KEY_ID
  config.aws_secret_access_key = S3_SECRET_ACCESS_KEY
  config.fog_directory         = S3_BUCKET
  config.gzip_compression      = true
  config.manifest              = false
end

