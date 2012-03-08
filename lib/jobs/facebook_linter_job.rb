class Jobs::FacebookLinterJob < Struct.new(:id)   
  
  def perform
    RestClient.post('https://graph.facebook.com', :id => "http://www.shelterexchange.org/save_a_life/#{id}", :scrape => true)
  end

end

# https://graph.facebook.com?id=http://www.shelterexchange.org/save_a_life/647&scrape=true
#https://developers.facebook.com/tools/lint/?url={YOUR_URL}&format=json

# curl -X POST \
#      -F "id=http://www.shelterexchange.org/save_a_life/1238" \
#      -F "scrape=true" \
#      "https://graph.facebook.com"

# https://graph.facebook.com?id=http://www.shelterexchange.org/save_a_life/1238&scrape=true