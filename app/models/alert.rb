class Alert < ActiveRecord::Base
  default_scope :order => 'created_at DESC'
  
  # Associations
  belongs_to :alertable, :polymorphic => true
  belongs_to :alert_type, :readonly => true
  
  # Validations
  validates_presence_of :title
  validates_presence_of :alert_type_id, :message => 'needs to be selected'
  validates_presence_of :description
  
  # Callbacks
  
  # Scopes
  scope :for_global, :include => [:alert_type], :conditions => { :alertable_type => nil }
  scope :for_animals, :include => [:alert_type, :alertable], :conditions => { :alertable_type => "Animal" }
  
end
