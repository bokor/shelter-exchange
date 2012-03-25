module Document
  extend ActiveSupport::Concern
  
  included do
    
    # Callbacks
    #----------------------------------------------------------------------------
    after_validation :revert_document?  
    
    # Constants
    #----------------------------------------------------------------------------
    DOCUMENT_SIZE = 5.megabytes
    DOCUMENT_SIZE_IN_TEXT = "5 MB"
    DOCUMENT_TYPE = ["501(c)(3) determination letter", "990 tax form", "Your adoption contract"]
    
    # Associations
    #----------------------------------------------------------------------------
    has_attached_file :document, :whiny => true, 
                                 :storage => :s3,
                                 :s3_credentials => S3_CREDENTIALS,
                                 :path => "/:class/:attachment/:id/:style/:basename.:extension"

    # Callback - Paperclip
    #----------------------------------------------------------------------------
    before_post_process :document_valid?
    
    # Validations
    #----------------------------------------------------------------------------
    validates :document_type, :presence => { :in => DOCUMENT_TYPE }
    

    # Validations - PaperClip
    #----------------------------------------------------------------------------
    validates_attachment_size :document, :less_than => DOCUMENT_SIZE, :message => "needs to be #{DOCUMENT_SIZE_IN_TEXT} megabytes or less"
    validates_attachment_presence :document, :message => "must be uploaded"
  
  end
  
  private

    def document_valid?
      self.document_file_size < DOCUMENT_SIZE
    end

    def revert_document?
      if self.errors.present? and self.document.file? and self.document_file_name_changed?
        self.document.instance_write(:file_name, self.document_file_name_was) 
        self.document.instance_write(:file_size, self.document_file_size_was) 
        self.document.instance_write(:content_type, self.document_content_type_was)
        errors.add(:upload_document_again, "please re-upload the document")
      end
    end


end
