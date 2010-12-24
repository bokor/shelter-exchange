class Alert < ActiveRecord::Base
  default_scope :order => 'created_at DESC'
  
  # Set up so the section value could be translated and the first is stored in the database
  SEVERITY = { :high => "High", 
               :medium => "Medium", 
               :low => "Low" }
  
  # Associations
  belongs_to :shelter
  belongs_to :alertable, :polymorphic => true
  
  # Validations
  validates_presence_of :title
  validates_presence_of :severity, :message => 'needs to be selected'
  validates_presence_of :description
  
  # Scopes
  scope :stopped, where(:is_stopped => true)
  scope :not_stopped, where(:is_stopped => false)
  
  scope :is_broadcast, where(:is_broadcast => true)
  
  scope :for_shelter, where(:alertable_type => nil)
  scope :for_animals, includes(:alertable).where(:alertable_type => "Animal")
  
end
