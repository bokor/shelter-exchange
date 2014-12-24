class DocumentUploader < CarrierWave::Uploader::Base
  storage :fog

  # S3 Directory
  #----------------------------------------------------------------------------
  def store_dir
    "#{model.attachable_type.to_s.pluralize.underscore}/#{model.class.to_s.pluralize.underscore}/#{model.attachable_id}/#{version_name || :original}"
  end

  # Filename name for all versions (can be placed in the version blocks)
  #----------------------------------------------------------------------------
  def full_filename (for_file = model.document.file)
    for_file
  end

  # Database Filename
  #----------------------------------------------------------------------------
  def filename
    "#{model.guid}#{File.extname(original_filename)}".downcase if original_filename
  end
end

