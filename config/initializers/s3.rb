require "yaml"

S3_CREDENTIALS = YAML.load_file(Rails.root.join("config/s3.yml"))



require "aws/s3"

unless AWS::S3::Base.connected?
  AWS::S3::Base.establish_connection!(
          :access_key_id => S3_CREDENTIALS["common"]["access_key_id"],
          :secret_access_key => S3_CREDENTIALS["common"]["secret_access_key"])
end
