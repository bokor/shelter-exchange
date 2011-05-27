require "yaml"

S3_CREDENTIALS = YAML.load_file(Rails.root.join("config/s3.yml"))

require "aws/s3"

S3_BUCKET      = S3_CREDENTIALS[Rails.env]["bucket"] 
S3_ACL         = S3_CREDENTIALS[Rails.env]["acl"]
S3_CONNECTED   = AWS::S3::Base.connected?

unless AWS::S3::Base.connected?
  AWS::S3::Base.establish_connection!(
          :access_key_id => S3_CREDENTIALS["common"]["access_key_id"],
          :secret_access_key => S3_CREDENTIALS["common"]["secret_access_key"])
end
