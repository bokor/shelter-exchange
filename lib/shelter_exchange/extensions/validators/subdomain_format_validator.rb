class SubdomainFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /^[A-Za-z0-9-]+$/
      record.errors.add(attribute, options[:message] || "can only contain letters, numbers, or hyphens.  No spaces allowed!")
    end

    if value =~ /^[\W0-9]+|\W+$/
      record.errors.add(attribute, options[:message] || "has to start and end with a letter")
    end

    if RESERVED_SUBDOMAINS.include?(value)
      record.errors.add(attribute, options[:message] || "is reserved and unavailable.")
    end
  end
end
