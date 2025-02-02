class PhotoUploader < CarrierWave::Uploader::Base
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper
  include CarrierWave::MiniMagick

  storage :fog

  # File Versions
  #----------------------------------------------------------------------------
  process :fix_exif_orientation
  process :resize_to_limit => [800,800]

  version :large  do
    process :resize_to_limit => [500,400]
  end

  version :small do
    process :resize_to_limit => [250,150]
  end

  version :thumb do
    process :resize_to_fill => [100,75, "North"]
  end

  # S3 Directory
  #----------------------------------------------------------------------------
  def store_dir
    # TODO: Move to /animals/{animal_id}/photos/{photo_id} or /photos/{photo_id}
    #       instead of /animals/photos/{animal_id} (requires copy to new model (example AnimalPhotoUploader - can rename later)
    "#{model.attachable_type.to_s.pluralize.underscore}/#{model.class.to_s.pluralize.underscore}/#{model.attachable_id}/#{version_name || :original}"
  end

  # Default URL
  #----------------------------------------------------------------------------
  def default_url
    asset_path("default_#{version_name || :original}_photo.jpg")
  end

  # File Extensions Allowed
  #----------------------------------------------------------------------------
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Filename name for all versions (can be placed in the version blocks)
  #----------------------------------------------------------------------------
  def full_filename (for_file = model.image.file)
    for_file
  end

  # Database Filename
  #----------------------------------------------------------------------------
  def filename
    "#{model.guid}#{File.extname(original_filename)}".downcase if original_filename
  end
end

