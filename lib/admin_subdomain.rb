class AdminSubdomain
  def self.matches?(request)
    request.subdomain.blank? or request.subdomain == "admin"
  end
end