class AppSubdomain
  def self.matches?(request)
    # request.subdomain.present? and !RESERVED_SUBDOMAINS.include?(request.subdomains.last)
    !RESERVED_SUBDOMAINS.include?(request.subdomains.last)
  end
end