class SubdomainFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    object.errors[attribute] << (options[:message] || "can only contain letters, numbers, or hyphens.  No spaces allowed!") unless value =~ SUBDOMAIN_REGEX
    object.errors[attribute] << (options[:message] || "is reserved and unavailable.") if RESERVED_SUBDOMAINS.include?(value)
  end
end
