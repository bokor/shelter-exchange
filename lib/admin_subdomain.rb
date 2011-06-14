class AdminSubdomain
  def self.matches?(request)
    request.subdomain.present? and %w(manage admin).include?(request.subdomain)
  end
end