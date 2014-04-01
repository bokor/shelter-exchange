class Transfer < ActiveRecord::Base
  default_scope :order => 'transfers.created_at DESC'

  # Callbacks
  #----------------------------------------------------------------------------
  after_create :send_notification_of_transfer_request

  after_save :create_transfer_history!, :if => :transfer_history_reason
  after_save :transfer_animal_record!, :if => :completed?
  after_save :send_notification_of_status_change

  # Getter/Setter
  #----------------------------------------------------------------------------
  attr_accessor :transfer_history_reason

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
  scope :approved, where(:status => "approved")
  scope :rejected, where(:status => "rejected")
  scope :completed, where(:status => "completed")
  scope :active, where("transfers.status IS NULL or transfers.status = ?", "approved")

  # Instance Methods
  #----------------------------------------------------------------------------
  def new_request?
    self.status.blank?
  end

  def approved?
    self.status == "approved"
  end

  def rejected?
    self.status == "rejected"
  end

  def completed?
    self.status == "completed"
  end


  #----------------------------------------------------------------------------
  private

  def send_notification_of_transfer_request
    TransferMailer.delay.requestor_new_request(self)
    TransferMailer.delay.requestee_new_request(self, self.transfer_history_reason)
  end

  def send_notification_of_status_change
    unless self.new_record? || self.new_request?
      case self.status
      when "approved"
        TransferMailer.delay.approved(self, self.transfer_history_reason)
      when "rejected"
        TransferMailer.delay.rejected(self, self.transfer_history_reason)
      when "completed"
        TransferMailer.delay.requestor_completed(self, self.transfer_history_reason)
        TransferMailer.delay.requestee_completed(self, self.transfer_history_reason)
      end
    end
  end

  def create_transfer_history!
    TransferHistory.create_with(self.shelter_id, self.id, self.status, self.transfer_history_reason)
  end

  def transfer_animal_record!
    self.animal.animal_status_id      = AnimalStatus::STATUSES[:new_intake]
    self.animal.status_history_reason = "Transferred from #{self.shelter.name}"
    self.animal.status_change_date    = Time.zone.now.to_date
    self.animal.shelter_id            = self.requestor_shelter.id
    self.animal.arrival_date          = Time.zone.now.to_date
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

