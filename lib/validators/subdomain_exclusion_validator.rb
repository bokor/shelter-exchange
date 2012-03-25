class SubdomainExclusionValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    if RESERVED_SUBDOMAINS.include?(value)
      object.errors[attribute] << (options[:message] || "is reserved and unavailable.") 
    end
  end
end