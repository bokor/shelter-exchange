class Jobs::FacebookLinterJob < Struct.new(:id)   
  
  def perform
    RestClient.post('https://graph.facebook.com', :id => "http://www.shelterexchange.org/save_a_life/#{id}", :scrape => true)
  end

end
