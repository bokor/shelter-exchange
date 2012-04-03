class VideoUrlFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, options[:message] || "incorrect You Tube URL format") unless value =~ VIDEO_URL_REGEX
  end
end