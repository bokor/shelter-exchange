class TwitterFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /@(?:[A-Za-z0-9]_?)*\z/
      record.errors.add(attribute, options[:message] || "format is incorrect. Example @shelterexchange")
    end
  end
end
