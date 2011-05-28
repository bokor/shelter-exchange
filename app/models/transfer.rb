class Transfer < ActiveRecord::Base
  default_scope :order => 'created_at DESC'
  
  after_save :transfer_record?
  
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
  scope :approved, where(:approved => true)
  scope :completed, where(:completed => true)
  scope :approved_and_completed, where(:approved => true, :completed => true)
  scope :not_completed, where(:completed => false)
                    
                    
  private
    def transfer_record?
      self.animal.complete_transfer_request!(self.shelter, self.requestor_shelter) if self.approved and self.completed
    end

end

#, :allow_destroy => true #, :reject_if => proc { |attributes| attributes['comment'].blank? }
