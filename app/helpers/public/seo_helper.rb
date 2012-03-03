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

  def seo_location(seo_location)
    content_for(:seo_location) { seo_location.to_s }
  end
  
  def seo_image(seo_image)
    content_for(:seo_image) { seo_image.to_s }
  end
  #----------------------------------------------------------------------------
  
  
  # Open Graph Helpers
  #----------------------------------------------------------------------------
  def open_graph_type
    page_name == "home_page" ? "website" : "article"
  end
  #----------------------------------------------------------------------------

  
  # Social Media - Pinterest Helpers
  #----------------------------------------------------------------------------
  def pinterest_animal_description(animal, shelter)
    str = animal.available_for_adoption? ? "Available for adoption - " : ""
		str += "#{animal.name} is a #{animal.sex.downcase} #{animal.animal_type.name.downcase}, #{animal.full_breed}, located at #{shelter.name} in #{shelter.city}, #{shelter.state}."
		str
  end
  
  def pinterest_shelter_description(shelter)
    "Help the #{shelter.name}, located in #{shelter.city}, #{shelter.state}, by adopting an animal or donating items most needed at this shelter or rescue group."
  end
  
  #----------------------------------------------------------------------------

  
end