module SheltersHelper
  def setup_items(shelter)
    5.times { shelter.items.build } if shelter.items.blank?
    shelter
  end
end
