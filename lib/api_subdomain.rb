class ApiSubdomain
  def self.matches?(request)
    request.subdomain.present? and %w(api).include?(request.subdomain)
  end
end