class Transfer < ActiveRecord::Base
  default_scope :order => 'created_at DESC'
  
  after_save :transfer_animal_record!
  
  attr_accessor :email_note
  
  # Associations
  belongs_to :shelter, :class_name => "Shelter", :readonly => true
  belongs_to :requestor_shelter, :class_name => "Shelter", :readonly => true
  belongs_to :animal
  
  # Validations
  validates :requestor, :presence => true
  validates :phone, :presence => true
  validates :email, :presence => true,
                    :format => {:with => EMAIL_FORMAT, :message => "format is incorrect"}
 
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
    def transfer_animal_record!
      self.animal.complete_transfer_request!(self.shelter, self.requestor_shelter) if self.completed?
    end

end



