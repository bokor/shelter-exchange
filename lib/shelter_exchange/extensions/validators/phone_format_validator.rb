class PhoneFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.blank? || value =~ /^\+?\d+(-\d+)*$/  # or /\(?([0-9]{3})\)?([ .-]?)([0-9]{3})\2([0-9]{4})/
      record.errors.add(attribute, options[:message] || "invalid phone number format")
    end
  end
end


