module ShelterExchange
  module Subdomains
    class Admin
      def self.matches?(request)
        request.subdomain.present? && %w(manage admin).include?(request.subdomain)
      end
    end

    class Api
      def self.matches?(request)
        request.subdomain.present? && %w(api).include?(request.subdomain)
      end
    end

    class App
      def self.matches?(request)
        request.subdomain.present? && !RESERVED_SUBDOMAINS.include?(request.subdomains.last)
      end
    end

    class Public
      def self.matches?(request)
        request.subdomain.blank? || request.subdomain == "www"
      end
    end
  end
end

