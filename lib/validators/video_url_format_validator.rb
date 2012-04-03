class VideoUrlFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    object.errors[attribute] << (options[:message] || "incorrect You Tube URL format") unless value =~ VIDEO_URL_REGEX
  end
end