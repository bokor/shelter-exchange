class AdminSubdomain
  def self.matches?(request)
    request.subdomain.present? and request.subdomains.first == "admin"
  end
end