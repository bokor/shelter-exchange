class Transfer < ActiveRecord::Base
  default_scope :order => 'transfers.created_at DESC'

  # Callbacks
  #----------------------------------------------------------------------------
  after_save :create_transfer_history!, :transfer_animal_record!

  # Getter/Setter
  #----------------------------------------------------------------------------
  attr_accessor :transfer_history_reason

  # Constants
  #----------------------------------------------------------------------------
  APPROVED  = "approved"
  REJECTED  = "rejected"
  COMPLETED = "completed"

  # Associations
  #----------------------------------------------------------------------------
  belongs_to :shelter, :class_name => "Shelter", :readonly => true
  belongs_to :requestor_shelter, :class_name => "Shelter", :readonly => true
  belongs_to :animal

  has_many :transfer_histories, :dependent => :destroy

  # Validations
  #----------------------------------------------------------------------------
  validates :requestor, :presence => true
  validates :phone, :presence => true
  validates :email, :presence => true, :email_format => true

  validates :transfer_history_reason, :presence => { :if => :transfer_history_reason_required? }

  # Scopes
  #----------------------------------------------------------------------------
  scope :approved, where(:status => APPROVED)
  scope :rejected, where(:status => REJECTED)
  scope :completed, where(:status => COMPLETED)
  scope :active, where("transfers.status IS NULL or transfers.status = ?", APPROVED)

  # Instance Methods
  #----------------------------------------------------------------------------
  def new_request?
    self.status.blank?
  end

  def approved?
    self.status == APPROVED
  end

  def rejected?
    self.status == REJECTED
  end

  def completed?
    self.status == COMPLETED
  end


  #----------------------------------------------------------------------------
  private

  def transfer_history_reason_required?
    self.rejected?
  end

  def create_transfer_history!
    TransferHistory.create_with(self.shelter_id, self.id, self.status, @transfer_history_reason) unless @transfer_history_reason.blank?
  end

  def transfer_animal_record!
    self.animal.complete_transfer_request!(self.shelter, self.requestor_shelter) if self.completed?
  end
end

