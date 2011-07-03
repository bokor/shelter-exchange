module MapsHelper
  
  def shelter_info_window(shelter)
    output =  '<ul>'
    output << '<li>' << shelter.street << '</li>'
    output << '<li>' << shelter.street_2 << '</li>' unless shelter.street_2.blank?
    output << '<li style="padding-bottom: 10px;">' << shelter.city << ', ' << shelter.state << ' ' << shelter.zip_code << '</li>' 
    output << '<li><strong>Phone:</strong> ' << number_to_phone(shelter.phone, :delimiter => "-") << '</li>' unless shelter.phone.blank?
    output << '<li><strong>Email:</strong> <a href="mailto:' << shelter.email << '">' << shelter.email << '</a></li>' unless shelter.email.blank?
    output << '<li><strong>Website:</strong> <a href="' << shelter.website << '" target="_blank">' << shelter.website << '</a></li>' unless shelter.website.blank?
    output << '</ul>'
    output << '<div style="width:100%; text-align:center; margin: 0 auto; padding-top: 5px;"><img src="' << shelter.logo.url(:thumb) << '" alt="" /></div>' if shelter.logo.file?
    return output
  end
  
end
