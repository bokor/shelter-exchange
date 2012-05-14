module PhotosHelper
  
  def setup_photos(animal)
    animal.photos.reject!{|photo| !photo.main_photo? }
    size = animal.photos.size
    if size == 0
      1.times{|n| animal.photos.build(:is_main_photo => true) }
    end
    animal
  end  
  # total_photos = 4
  # size = animal.photos.size
  # (total_photos-size).times{|n| animal.photos.build(:is_main_photo => (size == 0 && n==0 ? 1 : 0)) }
  # animal
  
  def polymorphic_photo_url(photo, version)
    version = version == :original ? nil : version
    if defined?(photo.image)
      photo.image.url(version)
    else
      version.blank? ? PhotoUploader.new.default_url : PhotoUploader.new.send(version).default_url
    end
  end
  
end


# Method to use if we wanted to resize photos based on the orignal or a larger image to downscale
#
# def polymorphic_photo_image_tag(photo, version)
#   version = :medium
#   if version == :original or version == :thumb
#     url = polymorphic_photo_url(photo, version)
#     image_tag(url)
#   else
#     url = polymorphic_photo_url(photo, :original)
#     size = {}
#     unless url.include?("images/default_#{version.to_s}")
#       case version
#         when :large
#           size = 500>200 ? { :width => "500" } : { :height => "400" }
#         when :medium
#           size = 500>200 ? { :width => "350" } : { :height => "250" }
#         when :small
#           size = 500>200 ? { :width => "250" } : { :height => "150" }
#       end
#     end
#     image_tag(url, size)
#   end
# end
