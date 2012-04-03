class TwitterFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    object.errors[attribute] << (options[:message] || "format is incorrect. Example @shelterexchange") unless value =~ TWITTER_USERNAME_REGEX
  end
end