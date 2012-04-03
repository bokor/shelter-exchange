class PhoneFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    object.errors[attribute] << (options[:message] || "invalid phone number format") unless value =~ PHONE_REGEX
  end
end


