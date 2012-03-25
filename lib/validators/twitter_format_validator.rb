class TwitterFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    unless value =~ TWITTER_USERNAME_REGEX
      object.errors[attribute] << (options[:message] || "format is incorrect. Example @shelterexchange") 
    end
  end
end