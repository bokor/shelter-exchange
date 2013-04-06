class PhotoPresenter < Presenter

  def initialize(photo)
    @photo = photo
  end

  def self.as_uploader_collection(photos)
    photos.reject(&:main_photo?).collect{|photo| self.new(photo).to_uploader }.flatten.to_json
  end

  def self.as_gallery_collection(photos)
    unless photos.blank?
      photos.collect{|photo| self.new(photo).to_gallery }.flatten.to_json
    else
      self.to_blank_gallery.to_json
    end
  end

  def to_uploader
    [{
      "name" => @photo.original_name,
      "url" => @photo.image.url,
      "thumbnail_url" => @photo.image.url(:thumb),
      "delete_url" => photo_path(@photo),
      "delete_type" => "DELETE"
    }]
  end

  def to_gallery
    [{
      :thumb       => @photo.image.url(:thumb),
      :image       => @photo.image.url(:large),
      :big         => @photo.image.url,
      :title       => @photo.attachable.name,
      :description => @photo.attachable.full_breed
    }]
  end

  def self.to_blank_gallery
    [{
      :thumb => help.polymorphic_photo_url(nil, :large),
      :image => help.polymorphic_photo_url(nil, :large),
      :big   => help.polymorphic_photo_url(nil, :large),
      :title => "No photo provided"
    }]
  end
end

