module PhotosHelper

  def setup_photos(animal)
    animal.photos.reject!{|photo| !photo.main_photo? }

    if animal.photos.size == 0
      1.times{|n| animal.photos.build(:is_main_photo => true) }
    end

    animal
  end

  def polymorphic_photo_url(photo, version)
    version = version == :original ? nil : version
    if defined?(photo.image)
      photo.image.url(version)
    else
      version.blank? ? PhotoUploader.new.default_url : PhotoUploader.new.send(version).default_url
    end
  end
end

