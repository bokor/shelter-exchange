class Account < ActiveRecord::Base
  
  # Callbacks
  #----------------------------------------------------------------------------
  before_validation :downcase_subdomain, :assign_owner_role
  after_validation :revert_document?
  
  # Constants
  #----------------------------------------------------------------------------
  DOCUMENT_SIZE = 5.megabytes
  DOCUMENT_SIZE_IN_TEXT = "5 MB"
  DOCUMENT_TYPE = ["501(c)(3) determination letter", "990 tax form", "Your adoption contract"]
  
  # Associations
  #----------------------------------------------------------------------------
  has_many :users, :uniq => true, :dependent => :destroy
  has_many :shelters, :dependent => :destroy
  
  has_attached_file :document, :whiny => true, 
                               :storage => :s3,
                               :s3_credentials => S3_CREDENTIALS,
                               # :s3_protocol => "https",
                               :path => "/:class/:attachment/:id/:style/:basename.:extension"
    
  # Callback - Paperclip
  #----------------------------------------------------------------------------
  before_post_process :document_valid?

  # Nested Attributes
  #----------------------------------------------------------------------------  
  accepts_nested_attributes_for :users
  accepts_nested_attributes_for :shelters
  
  # Validations
  #----------------------------------------------------------------------------
  validates :subdomain, :presence => true,
                        :uniqueness => true,
                        :format => { :with => SUBDOMAIN_FORMAT, :message => "can only contain alphanumeric characters; A-Z, 0-9 or hyphen.  No spaces allowed!" },
                        :exclusion => { :in => RESERVED_SUBDOMAINS, :message => "is reserved and unavailable."}
  validates :document_type, :presence => { :in => DOCUMENT_TYPE }
  
  # Validations - PaperClip
  #----------------------------------------------------------------------------
  validates_attachment_size :document, :less_than => DOCUMENT_SIZE, :message => "needs to be #{DOCUMENT_SIZE_IN_TEXT} megabytes or less"
  validates_attachment_presence :document, :message => "must be uploaded"


  # Class Methods
  #----------------------------------------------------------------------------

           
  # Instance Methods
  #----------------------------------------------------------------------------
  def approved?
    !self.blocked
  end
  
  def blocked?
    self.blocked
  end
  
  private

    def downcase_subdomain
      self.subdomain.downcase! if attribute_present?(:subdomain)
    end
   
    def assign_owner_role
      self.users.first.role = User::OWNER
    end
    
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