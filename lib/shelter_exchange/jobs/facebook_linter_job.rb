module ShelterExchange
  module Jobs
    class FacebookLinterJob < Struct.new(:id)

      def perform
        unless id.blank?
          uri = URI("https://graph.facebook.com")
          Net::HTTP.post_form(uri, :id => "http://www.shelterexchange.org/save_a_life/#{id}", :scrape => true)
        end
      end
    end
  end
end

