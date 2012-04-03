class EmailFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.blank? or value =~ EMAIL_REGEX
      record.errors.add(attribute, options[:message] || "format is incorrect")
    end
  end
end