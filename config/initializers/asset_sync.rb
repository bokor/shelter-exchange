AssetSync.configure do |config|
  config.fog_provider          = 'AWS'
  config.aws_access_key_id     = S3_ACCESS_KEY_ID
  config.aws_secret_access_key = S3_SECRET_ACCESS_KEY
  config.fog_directory         = S3_BUCKET
  config.gzip_compression      = true
  config.manifest              = false
end

  # existing_remote_files: delete
  # To ignore existing remote files and overwrite.
  # existing_remote_files: ignore
  # Automatically replace files with their equivalent gzip compressed version
  # gzip_compression: true
  # Fail silently.  Useful for environments such as Heroku
  # fail_silently: true
  # Always upload. Useful if you want to overwrite specific remote assets regardless of their existence
  #  eg: Static files in public often reference non-fingerprinted application.css
  #  note: You will still need to expire them from the CDN's edge cache locations
  # always_upload: ['application.js', 'application.css']
  # Ignored files. Useful if there are some files that are created dynamically on the server and you don't want to upload on deploy.
  # ignored_files: ['ignore_me.js', !ruby/regexp '/ignore_some/\d{32}\.css/']

