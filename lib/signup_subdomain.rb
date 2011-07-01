class SignupSubdomain
  def self.matches?(request)
    request.subdomain.present? and %w(signup register).include?(request.subdomain)
  end
end