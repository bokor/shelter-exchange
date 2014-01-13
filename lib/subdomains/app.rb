module Subdomains
  class App
    def self.matches?(request)
      request.subdomain.present? && !RESERVED_SUBDOMAINS.include?(request.subdomains.last)
    end
  end
end

