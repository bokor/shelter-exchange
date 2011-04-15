module MapsHelper
  
  def shelter_xml_description(shelter)
    '<ul>' +
      '<li>' + shelter.street + '</li>' +
      '<li>' + shelter.city + ', ' + shelter.state + ' ' + shelter.zip_code + '</li>' +
    '</ul>' +
    '<p><img src="http://www.designwaves.com/designwaves-icon.png" />testing this method call</p>'
  end
end
