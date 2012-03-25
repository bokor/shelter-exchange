class SubdomainFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    unless value =~ SUBDOMAIN_REGEX
      object.errors[attribute] << (options[:message] || "can only contain letters, numbers, or hyphens.  No spaces allowed!") 
    end
  end
end
