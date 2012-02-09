xml.instruct! 

xml.animals do
  @animals.each do |animal|
    xml.animal do
      xml.id(animal.id)
      xml.name(animal.name)
      xml.type(animal.animal_type.name)
      xml.status(animal.animal_status.name)
      xml.mixed_breed(animal.mix_breed?)
      xml.primary_breed(animal.primary_breed)
  		xml.secondary_breed(animal.secondary_breed)
  		xml.full_breed_in_text(animal.full_breed)
  		xml.sterilized(animal.sterilized? ? true : false)
  		xml.date_of_birth(animal.date_of_birth)
     	xml.date_of_birth_text(humanize_dob(animal.date_of_birth))
      xml.size(animal.size)
      xml.color(animal.color)
      xml.microchip(animal.microchip)
      xml.has_special_needs(animal.special_needs?)
      xml.special_needs(auto_link(simple_format(animal.special_needs), :all, :target => "_blank"))
      xml.description(auto_link(simple_format(animal.description), :all, :target => "_blank"))
      xml.weight(animal.weight)
      xml.sex(animal.sex.to_s.humanize)
      xml.euthanasia_info do
    	  xml.arrival_date(format_date(:default, animal.arrival_date))
    		xml.hold_time(animal.hold_time.blank? ? "" : "#{animal.hold_time} days")
    		xml.euthanasia_date(format_date(:default, animal.euthanasia_date))
      end
      xml.photo do 
        xml.thumbnail(animal.photo.file? ? animal.photo.url(:thumb) : "")
        xml.small(animal.photo.file? ? animal.photo.url(:small) : "")
        xml.large(animal.photo.file? ? animal.photo.url(:large) : "")
      end
      xml.video(animal.video_url || "")
      xml.url(public_save_a_life_url(animal, :subdomain => "www"))
    end
  end
end