module Subdomains
  class Public
    def self.matches?(request)
      request.subdomain.blank? || request.subdomain == "www"
    end
  end
end

