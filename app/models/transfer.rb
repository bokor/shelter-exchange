class Transfer < ActiveRecord::Base
  default_scope :order => 'transfers.created_at DESC'

  # Callbacks
  #----------------------------------------------------------------------------
  after_save :create_transfer_history!, :if => :transfer_history_reason
  after_save :transfer_animal_record!, :if => :completed?

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

  validates :transfer_history_reason, :presence => { :if => :rejected? }

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

  def create_transfer_history!
    TransferHistory.create_with(self.shelter_id, self.id, self.status, self.transfer_history_reason)
  end

  def transfer_animal_record!
    self.animal.animal_status_id      = AnimalStatus::STATUSES[:new_intake]
    self.animal.status_history_reason = "Transferred from #{self.shelter.name}"
    self.animal.status_change_date    = Date.today
    self.animal.shelter_id            = self.requestor_shelter.id
    self.animal.arrival_date          = Date.today
    self.animal.hold_time             = nil
    self.animal.euthanasia_date       = nil
    self.animal.accommodation_id      = nil
    self.animal.updated_at            = DateTime.now
    self.animal.save(:validate => false)

    # Update Notes to new Shelter
    self.animal.notes.update_all(:shelter_id => self.requestor_shelter.id)

    # Delete all Records not needed
    self.animal.status_histories.where(:shelter_id => self.shelter.id).delete_all
    self.animal.tasks.delete_all
    self.animal.alerts.delete_all
  end
end

