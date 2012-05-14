class PhotoPresenter < Presenter

  def initialize(photo)
    @photo = photo
  end
  
  def to_uploader
    {
      "name" => @photo.read_attribute(:image),
      # "size" => "",
      "url" => @photo.image.url,
      "thumbnail_url" => @photo.image.url(:thumb),
      "delete_url" => photo_path(@photo),
      "delete_type" => "DELETE" 
    }
  end
  
  def to_gallery
    {
      "thumb" => @photo.image.url(:thumb),
      "image" => @photo.image.url(:large),
      "big" => @photo.image.url,
      "title" => @photo.attachable.name,
      "description" => @photo.attachable.full_breed
    }
  end
  
  def self.blank_gallery
    {
	    "thumb" => help.polymorphic_photo_url(nil, :large),
	    "image" => help.polymorphic_photo_url(nil, :large),
	    "big" => help.polymorphic_photo_url(nil, :large),
	    "title" => "No photo provided"
	  }
  end
  
  def self.as_uploader(photos)
    photos.reject(&:main_photo?).collect{|object| self.new(object).to_uploader}.to_json
  end
  
  def self.as_gallery(photos)
    unless photos.blank?
      photos.collect{|object| self.new(object).to_gallery}.to_json
    else
      blank_gallery.to_json
    end
  end
  
end