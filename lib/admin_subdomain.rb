class AdminSubdomain
  def self.matches?(request)
    request.subdomains.blank? or request.subdomains.first == "admin"
  end
end