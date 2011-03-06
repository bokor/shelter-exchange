class PublicSubdomain
  def self.matches?(request)
    request.subdomain.blank? or request.subdomains.first == "www"
  end
end