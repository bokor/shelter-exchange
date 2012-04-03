class TwitterFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, options[:message] || "format is incorrect. Example @shelterexchange") unless value =~ TWITTER_USERNAME_REGEX
  end
end