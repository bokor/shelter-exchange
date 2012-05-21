class DocumentUploader < CarrierWave::Uploader::Base
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
  
  # # Filename name for all versions (can be placed in the version blocks)
  # #----------------------------------------------------------------------------    
  # def full_filename (for_file = model.document.file) 
  #   for_file
  # end
  # 
  # # Database Filename
  # #----------------------------------------------------------------------------    
  # def filename
  #   original_filename
  # end
    
end