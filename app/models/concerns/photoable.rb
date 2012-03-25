module Photoable
  extend ActiveSupport::Concern
  
  included do
    
    # Callbacks
    #----------------------------------------------------------------------------
    before_validation :delete_photo?
    after_validation :revert_photo?    
    
    # Getters/Setters
    #----------------------------------------------------------------------------  
    attr_accessor :delete_photo
    
    # Callbacks
    #----------------------------------------------------------------------------  
    PHOTO_TYPES = ["image/jpeg", "image/png", "image/gif", "image/pjpeg", "image/x-png"].freeze
    PHOTO_SIZE = 4.megabytes
    PHOTO_SIZE_IN_TEXT = "4 MB"

    # Associations
    #----------------------------------------------------------------------------
    has_attached_file :photo, :whiny => true, 
                              :default_url => "/images/default_:style_photo.jpg", 
                              :storage => :s3,
                              :s3_credentials => S3_CREDENTIALS,
                              :s3_headers => { 'Cache-Control' => 'max-age=31536000', 
                                               'Expires' => 1.year.from_now.httpdate # 1 year
                              }, 
                              :path => "/:class/:attachment/:id/:style/:basename.:extension",
                              :styles => { :small => ["250x150>", :jpg],
                                           :medium => ["350x250>", :jpg],
                                           :large => ["500x400>", :jpg], 
                                           :thumb => ["100x75#", :jpg] 
                              }
                                           
    # Callbacks - Paperclip
    #----------------------------------------------------------------------------
    before_post_process :photo_valid?                                       
    
    # Validations - PaperClip
    #----------------------------------------------------------------------------
    validates_attachment_size :photo, :less_than => PHOTO_SIZE, :message => "needs to be #{PHOTO_SIZE_IN_TEXT} or less"
    validates_attachment_content_type :photo, :content_type => PHOTO_TYPES, :message => "needs to be a JPG, PNG, or GIF file"
  end


  private

    def photo_valid?
      PHOTO_TYPES.include?(self.photo_content_type) and self.photo_file_size < PHOTO_SIZE
    end

    def revert_photo?
      if self.errors.present? and self.photo.file? and self.photo_file_name_changed?
        self.photo.instance_write(:file_name, self.photo_file_name_was) 
        self.photo.instance_write(:file_size, self.photo_file_size_was) 
        self.photo.instance_write(:content_type, self.photo_content_type_was)
        errors.add(:upload_photo_again, "please re-upload the photo")
      end
    end

    def delete_photo?
      self.photo.clear if delete_photo == "1" && !self.photo_file_name_changed?
    end

end
