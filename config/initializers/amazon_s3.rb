require "yaml"

S3_CREDENTIALS = YAML.load_file(Rails.root.join("config/s3_credentials.yml"))[Rails.env]

require "aws/s3"

S3_BUCKET      = S3_CREDENTIALS["bucket"] 
S3_ACL         = S3_CREDENTIALS["acl"]
S3_CONNECTED   = AWS::S3::Base.connected?

unless S3_CONNECTED
  AWS::S3::Base.establish_connection!(:access_key_id => S3_CREDENTIALS["access_key_id"],
                                      :secret_access_key => S3_CREDENTIALS["secret_access_key"])
end

#  AWS:S3 Cache Control Patch
module AWS
  module S3
    class S3Object
      class << self
        def store_with_cache_control(key, data, bucket = nil, options = {})
          options["Cache-Control"] = 'max-age=315360000' if options["Cache-Control"].blank?
          options["Expires"]       = 315360000.from_now.httpdate if options["Expires"].blank?
          
          store_without_cache_control(key, data, bucket, options)
        end

        alias_method_chain :store, :cache_control
      end
    end
  end
end