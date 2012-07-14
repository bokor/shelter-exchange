module ShelterExchange
  module Jobs
    class FacebookLinterJob < Struct.new(:id)   
  
      def perform
        begin
          RestClient.post('https://graph.facebook.com', :id => "http://www.shelterexchange.org/save_a_life/#{id}", :scrape => true)
        rescue
        end if Animal.exists?(:id => id)
      end
    
    end
  end
end