class VideoUrlFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    unless value =~ VIDEO_URL_REGEX
      object.errors[attribute] << (options[:message] || "incorrect You Tube URL format") 
    end
  end
end