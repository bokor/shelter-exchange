module Public::SeoHelper

  # SEO Helpers
  #----------------------------------------------------------------------------
  def description(description)
    content_for(:description) { description.to_s }
  end

  def keywords(keywords)
    content_for(:keywords) { keywords.to_s }
  end

  def robots(robots)
    content_for(:robots) { robots.to_s }
  end


  #----------------------------------------------------------------------------


  # Social Media - Open Graph Helpers
  #----------------------------------------------------------------------------
  def open_graph_image(open_graph_image)
    content_for(:open_graph_image) { open_graph_image.to_s }
  end

  def open_graph_title(open_graph_title)
    content_for(:open_graph_title) { open_graph_title.to_s }
  end

  def open_graph_title_status(animal)
    if animal.foster_care?
      "In #{animal.animal_status.name}! ".upcase
    elsif animal.deceased? or animal.euthanized?
      "Not available! ".upcase
    elsif animal.adopted? or animal.reclaimed? or animal.adoption_pending?
      "#{animal.animal_status.name}! ".upcase
    end
  end
  #----------------------------------------------------------------------------


  # Social Media - Pinterest Helpers
  #----------------------------------------------------------------------------
  def pinterest_animal_description(animal, shelter)
    str = if animal.available_for_adoption?
            "Available for adoption - "
          elsif animal.adoption_pending?
            "Adoption pending - "
          else
             ""
          end
		str += "#{animal.name} is a #{animal.sex.downcase} #{animal.animal_type.name.downcase}, #{animal.full_breed}, located at #{shelter.name} in #{shelter.city}, #{shelter.state}."
		str
  end

  def pinterest_shelter_description(shelter)
    "Help the #{shelter.name}, located in #{shelter.city}, #{shelter.state}, by adopting an animal or donating items most needed at this shelter or rescue group."
  end

end

