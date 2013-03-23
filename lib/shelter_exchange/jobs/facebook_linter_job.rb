module ShelterExchange
  module Jobs
    class FacebookLinterJob < Struct.new(:id)

      def perform
        begin
          if Animal.exists?(:id => id)
            RestClient.post('https://graph.facebook.com', :id => "http://www.shelterexchange.org/save_a_life/#{id}", :scrape => true)
          end
        rescue
        end
      end

    end
  end
end

