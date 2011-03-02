module UrlHelper
  def with_subdomain(subdomain)
    subdomain = (subdomain || "")
    subdomain += "." unless subdomain.empty?
    [subdomain, request.domain, request.port_string].join
  end
  
  def url_for(options = nil)
    if options.kind_of?(Hash) && options.has_key?(:subdomain)
      options[:host] = with_subdomain(options.delete(:subdomain))
    end
    super
  end
  
  def full_url
    request.port != 80 ? [request.protocol, request.host, ":", request.port].join : [request.protocol, request.host].join
  end
end