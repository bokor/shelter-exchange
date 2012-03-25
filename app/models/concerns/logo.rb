module Logo
  extend ActiveSupport::Concern
  
  included do

    # Callbacks
    #----------------------------------------------------------------------------
    before_validation :delete_logo?
    after_validation :revert_logo?

    # Constants
    #----------------------------------------------------------------------------
    LOGO_TYPES = ["image/jpeg", "image/png", "image/gif", "image/pjpeg", "image/x-png"].freeze
    LOGO_SIZE = 4.megabytes
    LOGO_SIZE_IN_TEXT = "4 MB"

    # Getter/Setter
    #----------------------------------------------------------------------------  
    attr_accessor :delete_logo

    # Assocations
    #----------------------------------------------------------------------------
    has_attached_file :logo, :whiny => true, 
                             :default_url => "/images/default_:style_logo.jpg", 
                             :storage => :s3,
                             :s3_credentials => S3_CREDENTIALS,
                             :s3_headers => { 'Cache-Control' => 'max-age=31536000', 
                                              'Expires' => 1.year.from_now.httpdate # 1 year
                              }, 
                             :path => "/:class/:attachment/:id/:style/:basename.:extension",
                             :styles => { :small => ["250x150>", :jpg],
                                          :medium => ["350x250>", :jpg],
                                          :large => ["500x400>", :jpg], 
                                          :thumb => ["150x75>", :jpg] 
                            
                            }
    # Callback - Paperclip
    #----------------------------------------------------------------------------
    before_post_process :logo_valid?

    # Validations - Paperclip
    #---------------------------------------------------------------------------- 
    validates_attachment_size :logo, :less_than => LOGO_SIZE, :message => "needs to be #{LOGO_SIZE_IN_TEXT} or less"
    validates_attachment_content_type :logo, :content_type => LOGO_TYPES, :message => "needs to be a JPG, PNG, or GIF file"

  end
  


  private

    def logo_valid?
      LOGO_TYPES.include?(self.logo_content_type) and self.logo_file_size < LOGO_SIZE
    end

    def revert_logo?
      if self.errors.present? and self.logo.file? and self.logo_file_name_changed?
        self.logo.instance_write(:file_name, self.logo_file_name_was) 
        self.logo.instance_write(:file_size, self.logo_file_size_was) 
        self.logo.instance_write(:content_type, self.logo_content_type_was)
        errors.add(:upload_logo_again, "please re-upload the logo")
      end
    end

    def delete_logo?
      self.logo.clear if delete_logo == "1" && !self.logo_file_name_changed?
    end

end
