xml.instruct! 

xml.animals do
  @animals.each do |animal|
    xml.animal do
      xml.id(animal.id)
      xml.name(animal.name)
      xml.type(animal.animal_type.name)
      xml.status(animal.animal_status.name)
      xml.breed(full_breed(animal))
      xml.microchip(animal.microchip)
      xml.estimated_age(humanize_dob(animal.date_of_birth))
      xml.color(animal.color)
      xml.description(animal.description)
      xml.is_sterilized(animal.is_sterilized)
      xml.weight(animal.weight)
      xml.sex(animal.sex.to_s.humanize)
      xml.euthanasia_info do
    	  xml.arrival_date(format_date(:default, animal.arrival_date))
    		xml.hold_time(animal.hold_time.blank? ? "" : "#{animal.hold_time} days")
    		xml.euthanasia_date(format_date(:default, animal.euthanasia_date))
      end
      xml.photo do 
        xml.thumbnail(animal.photo.url(:thumbnail))
        xml.small(animal.photo.url(:small))
        xml.large(animal.photo.url(:large))
      end
    end
  end
end
