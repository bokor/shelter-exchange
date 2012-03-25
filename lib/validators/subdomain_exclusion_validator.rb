class SubdomainExclusionValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    unless value =~ RESERVED_SUBDOMAINS
      object.errors[attribute] << (options[:message] || "is reserved and unavailable.") 
    end
  end
end