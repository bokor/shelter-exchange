class AppSubdomain
  def self.matches?(request)
    request.subdomain.present? and !RESERVED_SUBDOMAINS.include?(request.subdomains.first)
  end
end