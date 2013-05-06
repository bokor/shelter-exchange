require "yaml"
#http://www.engineyard.com/blog/2011/mocking-fog-when-using-it-with-carrierwave/

# S3 Credentials
#----------------------------------------------------------------------------
S3_CREDENTIALS = YAML.load_file(Rails.root.join("config/fog_credentials.yml"))

S3_BUCKET            = S3_CREDENTIALS[Rails.env]["bucket"]
S3_ACCESS_KEY_ID     = S3_CREDENTIALS[Rails.env]["access_key_id"]
S3_SECRET_ACCESS_KEY = S3_CREDENTIALS[Rails.env]["secret_access_key"]

