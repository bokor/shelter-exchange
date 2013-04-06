class Document < ActiveRecord::Base
  # Concerns
  include Uploadable

  # Callbacks
  #----------------------------------------------------------------------------
  before_create :set_original_name

  # Constants
  #----------------------------------------------------------------------------
  MAX_TOTAL = 4

  # Associations
  #----------------------------------------------------------------------------
  belongs_to :attachable, :polymorphic => true

  # Uploader
  #----------------------------------------------------------------------------
  mount_uploader :document, DocumentUploader

  # Validation
  #----------------------------------------------------------------------------
  validate :max_number_of_documents

  # Instance Methods
  #----------------------------------------------------------------------------
  def attachable?
    self.attachable.present?
  end

  #----------------------------------------------------------------------------
  private

  def set_original_name
    self.original_name = self.document.file.original_filename unless self.original_name
  end

  def max_number_of_documents
     max_total = Document.where(
       :attachable_id => self.attachable,
       :attachable_type => self.attachable.class.name
     ).count >= MAX_TOTAL

    if max_total
      errors.add(:base, "Max number of files exceeded")
    end
  end
end


