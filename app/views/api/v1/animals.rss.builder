# xml.instruct! :xml, :version => "1.0" 
# 
# xml.animals do
#   @animals.each do |animal|
#     xml.animal do
#       xml.id(animal.id)
#       xml.name(animal.name)
#       xml.type do 
#         xml.id(animal.animal_type_id)
#         xml.name(animal.animal_type.name)
#       end
#       xml.status do 
#         xml.id(animal.animal_status_id)
#         xml.name(animal.animal_status.name)
#       end
#       xml.breed(full_breed(animal))
#       xml.microchip(animal.microchip)
#       xml.estimated_age(humanize_dob(animal.date_of_birth))
#       xml.color(animal.color)
#       xml.description(animal.description)
#       xml.is_sterilized(animal.is_sterilized)
#       xml.weight(animal.weight)
#       xml.sex(animal.sex.to_s.humanize)
#       xml.photo do 
#         xml.thumbnail(animal.photo.url(:thumbnail))
#         xml.small(animal.photo.url(:small))
#         xml.large(animal.photo.url(:large))
#       end
#     end
#   end
# end
# 
# 
# 
# 
# 
# xml.rss :version => "2.0" do
#   xml.channel do
#     xml.title "#{possessive(@shelter.name)} animal list"
#     xml.description "All the animals listed here are for #{@shelter.name}"
# 
#     for post in @posts
#       xml.item do
#         xml.title post.title
#         xml.description post.content
#         xml.pubDate post.posted_at.to_s(:rfc822)
#         xml.link post_url(post)
#         xml.guid post_url(post)
#       end
#     end
#   end
# end

