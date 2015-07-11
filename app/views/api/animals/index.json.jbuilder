json.array! @animals do |animal|
  json.id animal.id
  json.name animal.name
  json.type animal.animal_type.name
  json.status animal.animal_status.name

  json.breed do
    json.mixed animal.mix_breed?
    json.primary animal.primary_breed
    json.secondary animal.secondary_breed
    json.full_text animal.full_breed
  end

  json.attributes do
    json.sterilized animal.sterilized?
    json.age_range animal.age.humanize
    json.date_of_birth animal.date_of_birth
    json.date_of_birth_in_text animal.date_of_birth.present? ? time_ago_in_words(animal.date_of_birth) : ""
    json.size Animal::SIZES[animal.size.to_sym]
    json.color animal.color
    json.weight animal.weight
    json.sex animal.sex.humanize
    json.microchip animal.microchip
  end

  json.special_needs animal.special_needs?
  json.special_needs_description auto_link(simple_format(animal.special_needs), :all, :target => "_blank")
  json.description_as_text animal.description
  json.description_as_html auto_link( simple_format(animal.description), :all, :target => "_blank")
  json.arrival_date format_date_for(animal.arrival_date)
  json.hold_time animal.hold_time.present? ? "#{animal.hold_time} days" : ""
  json.euthanasia_date format_date_for(animal.euthanasia_date)
  json.url public_save_a_life_url(animal, :subdomain => "www")
  json.video animal.video_url
  json.photos animal.photos do |photo|
    json.thumbnail photo.image.thumb.url
    json.small photo.image.small.url
    json.large photo.image.url
  end
end

