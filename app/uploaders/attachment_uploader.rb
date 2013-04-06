class AttachmentUploader < CarrierWave::Uploader::Base
  include CarrierWave::MimeTypes

  storage :fog

  # File Versions
  #----------------------------------------------------------------------------
  process :set_content_type => true

  # S3 Directory
  #----------------------------------------------------------------------------
  def store_dir
    "#{model.class.to_s.pluralize.underscore}/#{mounted_as.to_s.pluralize}/#{model.id}/#{version_name || :original}"
  end

end

