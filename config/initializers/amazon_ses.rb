require "yaml"

S3_CREDENTIALS = YAML.load_file(Rails.root.join("config/s3.yml"))[Rails.env]

ActionMailer::Base.add_delivery_method :ses, AWS::SES::Base,
  :access_key_id     => S3_CREDENTIALS["access_key_id"],
  :secret_access_key => S3_CREDENTIALS["secret_access_key"]