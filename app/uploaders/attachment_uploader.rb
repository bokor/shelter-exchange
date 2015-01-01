class AttachmentUploader < CarrierWave::Uploader::Base
  storage :fog

  # S3 Directory
  #----------------------------------------------------------------------------
  def store_dir
    "#{model.class.to_s.pluralize.underscore}/#{mounted_as.to_s.pluralize}/#{model.id}/#{version_name || :original}"
  end
end

