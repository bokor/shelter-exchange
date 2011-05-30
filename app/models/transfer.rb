class Transfer < ActiveRecord::Base
  default_scope :order => 'created_at DESC'
  
  after_save :create_transfer_history!, :transfer_animal_record!
  
  attr_accessor :transfer_history_reason
  
  # Associations
  belongs_to :shelter, :class_name => "Shelter", :readonly => true
  belongs_to :requestor_shelter, :class_name => "Shelter", :readonly => true
  belongs_to :animal
  has_many :transfer_histories, :dependent => :destroy
  
  # Validations
  validates :requestor, :presence => true
  validates :phone, :presence => true
  validates :email, :presence => true,
                    :format => {:with => EMAIL_FORMAT, :message => "format is incorrect"}
  
  validates :transfer_history_reason, :presence => { :if => :transfer_history_reason_required? }
  
  # Scopes  
  scope :approved, where(:status => "approved")
  scope :rejected, where(:status => "rejected")
  scope :completed, where(:status => "completed")
  scope :active, where("transfers.status IS NULL or transfers.status = ?", "approved")
  
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



