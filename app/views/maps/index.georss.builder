xml.instruct!
xml.rss :version => "2.0", "xmlns:georss" => "http://www.georss.org/georss" do
  xml.channel do
    xml.title("My GeoRSS feed")
    xml.link("http://www.example.com")
    xml.description("My posts enhanced with location info")
    xml.language('en-us')
    @shelters.each do |shelter|
      xml.item do
        xml.title shelter.name
        xml.description [shelter.street, shelter.city, shelter.state, shelter.zip_code].join(" ")
        xml.author "Brian Bokor"
        xml.pubDate shelter.created_at.strftime("%a, %d %b %Y %H:%M:%S %z")
        xml.link shelter_url(shelter)
        xml.icon image_path("logo_small.png")
        xml.guid shelter.id
        xml.georss :point do
          xml.text! shelter.lat.to_s + ' ' + shelter.lng.to_s
        end
      end
    end
  end
end