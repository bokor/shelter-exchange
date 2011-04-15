xml.instruct!
xml.kml :xmlns => "http://www.opengis.net/kml/2.2" do
  xml.Document do
    xml.name "Animal Shelters"
    xml.Style :id => "shelterExchangeLogo" do
      xml.IconStyle do
        xml.Icon do
          xml.href "http://www.designwaves.com/logo_small.png"
          # xml.href "/images/logo_small.png"
        end
      end
    end
    @shelters.each do |shelter|
      xml.Placemark do
        xml.name shelter.name
        xml.description do
           xml.cdata! shelter_xml_description(shelter)
        end
        xml.styleUrl "#shelterExchangeLogo"
        xml.Point do
          xml.coordinates  shelter.lng.to_s << ',' << shelter.lat.to_s << ',' << 0.to_s
        end
      end
    end
  end
end