class PublicSubdomain
  def self.matches?(request)
    request.subdomain.blank? or request.subdomain == "www"
  end
end