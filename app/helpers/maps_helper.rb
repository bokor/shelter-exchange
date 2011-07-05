module MapsHelper
  
  def shelter_info_window(shelter)
    output =  '<ul>'
    output << '<li>' << shelter.street << '</li>'
    output << '<li>' << shelter.street_2 << '</li>' unless shelter.street_2.blank?
    output << '<li>' << shelter.city << ', ' << shelter.state << ' ' << shelter.zip_code << '</li>' 
    output << '<li style="padding-bottom: 10px;">' << number_to_phone(shelter.phone, :delimiter => "-") << '</li>' unless shelter.phone.blank?
    unless shelter.email.blank? and shelter.website.blank?
      output << '<li>'
      output << '<strong style="padding:0 5px 0 0;"><a href="mailto:' << shelter.email << '">Email us</a></strong>' unless shelter.email.blank?
      output << '|' if shelter.email.present? and shelter.website.present?
      output << '<strong style="padding:0 0 0 5px;"><a href="' << shelter.website << '" target="_blank">Visit Website</a>' unless shelter.website.blank?
      output << '</li>'
    end
    output << '</ul>'
    output << '<div style="width:100%; text-align:center; margin: 0 auto;"><img src="' << shelter.logo.url(:thumb) << '" alt="" /></div>' if shelter.logo.file?
    return output
  end
  
end
