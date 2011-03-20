xml.instruct! 

xml.animals do
  @animals.each do |animal|
    xml.animal do
      xml.id(animal.id)
      xml.name(animal.name)
      xml.type do 
        xml.id(animal.animal_type_id)
        xml.name(animal.animal_type.name)
      end
      xml.status do 
        xml.id(animal.animal_status_id)
        xml.name(animal.animal_status.name)
      end
      xml.breed(full_breed(animal))
      xml.microchip(animal.microchip)
      xml.estimated_age(humanize_dob(animal.date_of_birth))
      xml.color(animal.color)
      xml.description(animal.description)
      xml.is_sterilized(animal.is_sterilized)
      xml.weight(animal.weight)
      xml.sex(animal.sex.to_s.humanize)
      xml.photo do 
        xml.thumbnail(animal.photo.url(:thumbnail))
        xml.small(animal.photo.url(:small))
        xml.large(animal.photo.url(:large))
      end
    end
  end
end
