class LogoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes

  storage :fog

  # File Versions
  #----------------------------------------------------------------------------
  process :set_content_type => true

  process :resize_to_limit => [500,500]

  version :small do
    process :resize_to_limit => [250,150]
  end

  version :thumb do
    process :resize_to_fit => [150,75]
  end

  # S3 Directory
  #----------------------------------------------------------------------------
  def store_dir
    "#{model.class.to_s.pluralize.underscore}/#{mounted_as.to_s.pluralize}/#{model.id}/#{version_name || :original}"
  end

  # Default URL
  #----------------------------------------------------------------------------
  def default_url
    "/images/default_#{version_name || :original}_logo.jpg"
  end

  # File Extensions Allowed
  #----------------------------------------------------------------------------
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Filename name for all versions (can be placed in the version blocks)
  #----------------------------------------------------------------------------
  def full_filename (for_file = model.logo.file)
    for_file
  end

  # Database Filename
  #----------------------------------------------------------------------------
  def filename
    "#{model.guid}#{File.extname(original_filename)}".downcase if original_filename
  end
end

