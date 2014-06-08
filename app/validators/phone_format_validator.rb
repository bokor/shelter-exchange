class PhoneFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # TODO: Remove dashes and count length based on US (10) and World (??) phone number lengths
    unless value.blank? || value =~ /^\+?\d+(-\d+)*$/  # or /\(?([0-9]{3})\)?([ .-]?)([0-9]{3})\2([0-9]{4})/
      record.errors.add(attribute, options[:message] || "invalid phone number format")
    end
  end
end


