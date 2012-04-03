class PhoneFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.blank? or value =~ PHONE_REGEX
      record.errors.add(attribute, options[:message] || "invalid phone number format") 
    end
  end
end


