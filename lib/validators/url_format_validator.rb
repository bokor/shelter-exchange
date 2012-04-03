class UrlFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, options[:message] || "format is incorrect") unless value =~ URL_REGEX
  end
end