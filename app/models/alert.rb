class Alert < ActiveRecord::Base
  default_scope :order => 'created_at DESC'
  
  # Constants
  SEVERITY = %w[high medium low].freeze
  
  # Associations
  belongs_to :shelter, :readonly => true
  belongs_to :alertable, :polymorphic => true
  
  # Validations
  validates :title, :presence => true
  validates :severity, :presence => {:message => 'needs to be selected'}
  
  # Scopes
  scope :active, where(:stopped => false)
  scope :stopped, where(:stopped => true)
  
  scope :for_shelter, where(:alertable_type => nil)
  scope :for_animals, includes(:alertable).where(:alertable_type => "Animal")
  
  # Scopes - Dashboard Only
  def self.recent_activity(shelter_id, limit=10)
    unscoped.where(:shelter_id => shelter_id).order("updated_at DESC").limit(limit)
  end
  
end