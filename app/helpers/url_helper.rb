module UrlHelper

  def with_subdomain(subdomain)
    subdomain = (subdomain || "")
    subdomain += "." unless subdomain.empty?
    host = Rails.application.routes.default_url_options[:host]
    [subdomain, host].join
  end

  def url_for(options = nil)
    if options.kind_of?(Hash) && options.has_key?(:subdomain)
      options[:host] = with_subdomain(options.delete(:subdomain))
    end
    #options[:protocol] ||= 'http'
    super
  end

  def full_url
    request.port != 80 ? [request.protocol, request.host, ":", request.port].join : [request.protocol, request.host].join
  end

  def api_url
    request.port != 80 ? [request.protocol, "api.", request.domain, ":", request.port].join : [request.protocol, "api.", request.domain].join
  end

  def s3_url(file_name, last_modified = false)
    query_string = last_modified ? "?#{FOG_BUCKET.files.head(file_name).last_modified.to_i}" : ""
    "https://#{S3_BUCKET}.s3.amazonaws.com/#{file_name}#{query_string}"
  end

end

