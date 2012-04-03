class UrlFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    object.errors[attribute] << (options[:message] || "format is incorrect") unless value =~ URL_REGEX
  end
end