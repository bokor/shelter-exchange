class SubdomainFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, options[:message] || "can only contain letters, numbers, or hyphens.  No spaces allowed!") unless value =~ SUBDOMAIN_REGEX
    record.errors.add(attribute, options[:message] || "is reserved and unavailable.") if RESERVED_SUBDOMAINS.include?(value)
  end
end
