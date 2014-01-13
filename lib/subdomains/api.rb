module Subdomains
  class Api
    def self.matches?(request)
      request.subdomain.present? && %w(api).include?(request.subdomain)
    end
  end
end

