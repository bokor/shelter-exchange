class Alert < ActiveRecord::Base
  default_scope :order => 'created_at DESC'
  
  # Constants
  SEVERITY = %w[high medium low]
  
  # Associations
  belongs_to :shelter
  belongs_to :alertable, :polymorphic => true
  
  # Validations
  validates :title, :presence => true
  validates :severity, :presence => {:message => 'needs to be selected'}
  
  # Scopes
  scope :active, where(:is_stopped => false)
  scope :stopped, where(:is_stopped => true)
  
  scope :for_shelter, where(:alertable_type => nil)
  scope :for_animals, includes(:alertable).where(:alertable_type => "Animal")
  
end