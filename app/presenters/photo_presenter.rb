class PhotoPresenter < Presenter

  def initialize(photos)
    @photos = photos
  end

  def to_uploader
    if @photos.is_a?(Array)
      @photos.reject(&:main_photo?).collect{|object| as_uploader(object)}.to_json
    elsif @photos.is_a?(Photo)
      [as_uploader(@photos)].to_json
    end
  end

  def to_gallery
    if @photos.blank?
      [as_blank_gallery].to_json
    elsif @photos.is_a?(Array)
      @photos.collect{|object| as_gallery(object)}.to_json
    elsif @photos.is_a?(Photo)
      [as_gallery(@photos)].to_json
    end
  end

  #-----------------------------------------------------------------------------
  private

  def as_uploader(photo)
    {
      "name" => photo.original_name,
      "url" => photo.image.url,
      "thumbnail_url" => photo.image.url(:thumb),
      "delete_url" => photo_path(photo),
      "delete_type" => "DELETE"
    }
  end

  def as_gallery(photo)
    {
      "thumb" => photo.image.url(:thumb),
      "image" => photo.image.url(:large),
      "big" => photo.image.url,
      "title" => photo.attachable.name,
      "description" => photo.attachable.full_breed
    }
  end

  def as_blank_gallery
    {
	    "thumb" => help.polymorphic_photo_url(nil, :large),
	    "image" => help.polymorphic_photo_url(nil, :large),
	    "big" => help.polymorphic_photo_url(nil, :large),
	    "title" => "No photo provided"
	  }
  end
end

