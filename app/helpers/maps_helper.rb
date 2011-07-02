module MapsHelper
  
  def shelter_xml_description(shelter)
    '<ul>' <<
      '<li>'<< shelter.name << '</li>' <<
      '<li>' << shelter.street << '</li>' << 
    	'<li>' << shelter.city << ', ' << shelter.state << ' ' << shelter.zip_code << '</li>' <<
    	'<li>Phone:' << shelter.phone << '</li>'
    	'<li>Email:' << link_to(shelter.email, "mailto:#{shelter.email}") << '</li>' <<
    	'<li>Website:' << link_to(shelter.website, shelter.website) << '</li>' <<
    '</ul>'
  end
  
end
