class PhoneFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    unless value =~ PHONE_REGEX
      object.errors[attribute] << (options[:message] || "invalid phone number format") unless value.blank?
    end
  end
end


