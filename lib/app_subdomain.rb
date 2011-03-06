class AppSubdomain
  def self.matches?(request)
    request.subdomain.present? && !RESERVED_SUBDOMAINS.include?(request.subdomains.first)
  end
end