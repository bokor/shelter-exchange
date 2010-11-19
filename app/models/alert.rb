class Alert < ActiveRecord::Base
  default_scope :order => 'created_at DESC'
  
  SEVERITY = { :high => "High", :medium => "Medium", :low => "Low" }
  
  # Associations
  belongs_to :shelter
  belongs_to :alertable, :polymorphic => true
  
  # Validations
  validates_presence_of :title
  validates_presence_of :severity, :message => 'needs to be selected'
  validates_presence_of :description
  
  # Scopes
  scope :stopped, :conditions => {"is_stopped" => true }
  scope :not_stopped, :conditions => {"is_stopped" => false }
  
  scope :for_global, :conditions => { :alertable_type => nil }
  scope :for_animals, :include => [:alertable], :conditions => { :alertable_type => "Animal" }
  
end
