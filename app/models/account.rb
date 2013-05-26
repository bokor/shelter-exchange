class Account < ActiveRecord::Base
  include Uploadable

  # Callbacks
  #----------------------------------------------------------------------------
  before_validation :downcase_subdomain, :assign_owner_role

  # Constants
  #----------------------------------------------------------------------------
  DOCUMENT_TYPE = ["501(c)(3) determination letter", "990 tax form", "Your adoption contract"]

  # Associations
  #----------------------------------------------------------------------------
  mount_uploader :document, AttachmentUploader

  has_many :users, :uniq => true, :dependent => :destroy
  has_many :shelters, :dependent => :destroy

  # Nested Attributes
  #----------------------------------------------------------------------------
  accepts_nested_attributes_for :users
  accepts_nested_attributes_for :shelters

  # Validations
  #----------------------------------------------------------------------------
  validates :document_type, :inclusion => { :in => DOCUMENT_TYPE }
  validates :subdomain, :presence => true, :uniqueness => true, :subdomain_format => true
  validates :document, :presence => true

  # Instance Methods
  #----------------------------------------------------------------------------
  def approved?
    !self.blocked
  end

  def blocked?
    self.blocked
  end


  #-----------------------------------------------------------------------------
  private

  def downcase_subdomain
    self.subdomain.downcase!
  end

  def assign_owner_role
    self.users.first.role = User::OWNER
  end
end

