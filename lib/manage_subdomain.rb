class ManageSubdomain
  def self.matches?(request)
    request.subdomain.present? and request.subdomains.first == "manage"
  end
end