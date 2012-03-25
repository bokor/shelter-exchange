class UrlFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    unless value =~ URL_REGEX
      object.errors[attribute] << (options[:message] || "format is incorrect") 
    end
  end
end