module Subdomains
  class Admin
    def self.matches?(request)
      request.subdomain.present? && %w(manage admin).include?(request.subdomain)
    end
  end
end

