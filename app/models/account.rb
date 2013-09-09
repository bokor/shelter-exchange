class Account < ActiveRecord::Base
  include Uploadable

  # Callbacks
  #----------------------------------------------------------------------------
  before_create :downcase_subdomain

  # Constants
  #----------------------------------------------------------------------------
  DOCUMENT_TYPE = ["501(c)(3) determination letter", "990 tax form", "Your adoption contract"]

  # Associations
  #----------------------------------------------------------------------------
  mount_uploader :document, AttachmentUploader

  has_many :users, :dependent => :destroy
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


  #-----------------------------------------------------------------------------
  private

  def downcase_subdomain
    self.subdomain.downcase!
  end
end

